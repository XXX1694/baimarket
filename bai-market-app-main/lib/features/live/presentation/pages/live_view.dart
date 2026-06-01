import 'package:bai_market/core/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../collection/presentation/cubit/collection_cubit.dart';
import '../widgets/live_items.dart';

class ChatMessage {
  final String id;
  final String message;
  final String userId;
  final String fullName;
  final String? avatarUrl;
  final bool isDeleted;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.message,
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    required this.isDeleted,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'].toString(),
      message: json['message'] ?? '',
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      avatarUrl: json['avatarUrl'],
      isDeleted: json['isDeleted'] ?? false,
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}

class VerticalYoutubeStreamScreen extends StatefulWidget {
  const VerticalYoutubeStreamScreen({super.key});

  @override
  State<VerticalYoutubeStreamScreen> createState() =>
      _VerticalYoutubeStreamScreenState();
}

class _VerticalYoutubeStreamScreenState
    extends State<VerticalYoutubeStreamScreen>
    with WidgetsBindingObserver {
  final _storage = SharedPreferences.getInstance();
  YoutubePlayerController? _controller;
  bool _isLoading = true;

  // --- ПЕРЕМЕННЫЕ СОСТОЯНИЯ ДЛЯ ДАННЫХ ИЗ API ---
  String? _streamId;
  String? _channelTitle;
  String? _viewerCount;
  String? _thumbnailUrl;
  final CollectionCubit collectionCubit = CollectionCubit();

  IO.Socket? socket;
  List<ChatMessage> chatMessages = [];
  int messageCount = 0;
  int viewerCount = 0;
  bool isStreamActive = false;
  bool isConnected = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  FocusNode _focusNode = FocusNode();
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    collectionCubit.getCollection(slug: 'new', sort: 'popular');
    _initSocket();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    socket?.dispose();
    _messageController.dispose();
    _chatScrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      _keyboardVisible = bottomInset > 0.0;
    });
    if (_keyboardVisible) {
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  void _initSocket() async {
    var storage = await _storage;
    String? token = storage.getString('auth_token');
    if (token == null) return;
    socket = IO.io('https://api.iris-cosmetics.kz', <String, dynamic>{
      'transports': ['websocket'],
      'auth': {'token': token},
    });
    socket!.on('connect', (_) {
      setState(() => isConnected = true);
      socket!.emit('joinStream');
    });
    socket!.on('disconnect', (_) {
      setState(() => isConnected = false);
      isStreamActive = false;
      chatMessages.clear();
      setState(() {});
    });
    socket!.on('streamStarted', (data) {
      setState(() {
        isStreamActive = true;
        _streamId = data['videoId'];
        _channelTitle = data['channelTitle'];
        _viewerCount = (data['viewerCount']?.toString() ?? '0');
        _thumbnailUrl = data['thumbnailUrl'];
        if (_streamId != null) {
          _controller = YoutubePlayerController(
            initialVideoId: _streamId!,
            flags: const YoutubePlayerFlags(
              isLive: true,
              autoPlay: true,
              mute: false,
              enableCaption: false,
              forceHD: true,
              hideControls: true,
              hideThumbnail: true,
            ),
          );
        }
      });
    });
    socket!.on('streamStopped', (_) {
      setState(() {
        isStreamActive = false;
        chatMessages.clear();
        _streamId = null;
        _controller = null;
        _channelTitle = null;
        _viewerCount = '0';
        _thumbnailUrl = null;
      });
    });
    socket!.on('viewerCountUpdate', (data) {
      setState(() {
        viewerCount = data['viewerCount'] ?? 0;
      });
    });
    socket!.on('messageCountUpdate', (data) {
      setState(() {
        messageCount = data['messageCount'] ?? 0;
      });
    });
    socket!.on('chatHistory', (data) {
      final List<ChatMessage> history =
          (data as List).map((e) => ChatMessage.fromJson(e)).toList();
      setState(() {
        chatMessages = history;
      });
      _scrollToBottom();
    });
    socket!.on('newMessage', (data) {
      final msg = ChatMessage.fromJson(data);
      setState(() {
        chatMessages.add(msg);
        if (chatMessages.length > 20) {
          chatMessages.removeAt(0);
        }
      });
      _scrollToBottom();
    });
    socket!.on('messageDeleted', (data) {
      setState(() {
        final idx = chatMessages.indexWhere(
          (m) => m.id == data['messageId'].toString(),
        );
        if (idx != -1) {
          chatMessages[idx] = ChatMessage(
            id: chatMessages[idx].id,
            message: chatMessages[idx].message,
            userId: chatMessages[idx].userId,
            fullName: chatMessages[idx].fullName,
            avatarUrl: chatMessages[idx].avatarUrl,
            isDeleted: true,
            timestamp: chatMessages[idx].timestamp,
          );
        }
      });
    });
    socket!.on('error', (data) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: ${data['message']}')));
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty && socket != null && isStreamActive) {
      socket!.emit('sendMessage', {'message': text});
      _messageController.clear();
    }
  }

  void _scrollToBottom() {
    if (_chatScrollController.hasClients) {
      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildChat() {
    return Container(
      height: _keyboardVisible ? 220 : 320,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Поле ввода всегда сверху
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  enabled: isStreamActive && isConnected,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText:
                        isStreamActive
                            ? 'Напишите сообщение...'
                            : 'Чат доступен только во время стрима',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: isStreamActive && isConnected ? _sendMessage : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child:
                chatMessages.isEmpty
                    ? Center(
                      child: Text(
                        isStreamActive
                            ? 'Сообщений пока нет'
                            : 'Чат будет доступен во время стрима',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    )
                    : ListView.builder(
                      controller: _chatScrollController,
                      itemCount: chatMessages.length,
                      itemBuilder: (context, index) {
                        final msg = chatMessages[index];
                        final initials =
                            msg.fullName.isNotEmpty
                                ? msg.fullName
                                    .split(' ')
                                    .map((e) => e[0])
                                    .join()
                                    .toUpperCase()
                                : '?';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white24,
                                child: Text(
                                  initials,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          msg.fullName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatTime(msg.timestamp),
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    msg.isDeleted
                                        ? Text(
                                          'Сообщение удалено',
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 13,
                                          ),
                                        )
                                        : Text(
                                          msg.message,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _streamId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Нет активного стрима")),
        body: const Center(
          child: Text('Стрим сейчас неактивен. Ожидайте начала.'),
        ),
      );
    }

    final screenSize = MediaQuery.of(context).size;
    final screenAspectRatio = screenSize.width / screenSize.height;

    return Scaffold(
      body: Stack(
        children: [
          // Плеер растягивается на весь фон
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: screenSize.width,
                height:
                    screenSize.width /
                    (16 / 9), // Пример для горизонтального видео
                child: YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: false,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      // --- АВАТАР КАНАЛА ИЗ API ---
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          // Используем Image.network для загрузки по URL
                          child:
                              _thumbnailUrl != null
                                  ? Image.network(
                                    _thumbnailUrl!,
                                    fit: BoxFit.cover,
                                    // Обработчик ошибок для изображения
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/person.png',
                                      ); // Запасное изображение
                                    },
                                  )
                                  : Image.asset('assets/images/person.png'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- НАЗВАНИЕ КАНАЛА ИЗ API ---
                            Text(
                              _channelTitle ?? 'Название канала',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/view.svg'),
                                const SizedBox(width: 5),
                                // --- КОЛИЧЕСТВО ЗРИТЕЛЕЙ ИЗ API ---
                                Text(
                                  _viewerCount ?? '0',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SvgPicture.asset('assets/icons/live_stream.svg'),
                      const SizedBox(width: 8),
                      CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () => context.pop(),
                        child: SvgPicture.asset(
                          'assets/icons/cancel_stream.svg',
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                BlocConsumer<CollectionCubit, CollectionState>(
                  bloc: collectionCubit,
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is CollectionGot) {
                      return HorizontalProductList(
                        products: state.collection.products,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Введите комментарии...',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        child: SvgPicture.asset(
                          'assets/icons/stream_cart.svg',
                          height: 32,
                          width: 32,
                        ),
                        onPressed: () => context.push('/cart'),
                      ),
                    ],
                  ),
                ),
                _buildChat(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
