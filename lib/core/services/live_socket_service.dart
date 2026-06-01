import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../features/live/data/models/chat_message.dart';
import '../../features/live/data/models/live_stream_info.dart';
import '../secure_token_storage.dart';
import 'live_logger.dart';

/// Тонкая обёртка над Socket.IO для лайв-стрима.
///
/// Отдаёт события в виде типизированных broadcast-стримов. Используется
/// `LiveCubit`-ом, который сам решает, что класть в state.
class LiveSocketService {
  LiveSocketService({LiveLogger? logger}) : _log = logger ?? const LiveLogger();

  static const _host = 'https://api.iris-cosmetics.kz';

  final LiveLogger _log;
  io.Socket? _socket;
  Future<bool>? _connecting;

  // Broadcast streams для всех событий, на которые подписан кубит.
  final _connection = StreamController<bool>.broadcast();
  final _streamStarted = StreamController<LiveStreamInfo>.broadcast();
  final _streamStopped = StreamController<void>.broadcast();
  final _viewerCount = StreamController<int>.broadcast();
  final _messageCount = StreamController<int>.broadcast();
  final _chatHistory = StreamController<List<ChatMessage>>.broadcast();
  final _newMessage = StreamController<ChatMessage>.broadcast();
  final _messageDeleted = StreamController<String>.broadcast();
  final _socketError = StreamController<String>.broadcast();

  Stream<bool> get connection => _connection.stream;
  Stream<LiveStreamInfo> get streamStarted => _streamStarted.stream;
  Stream<void> get streamStopped => _streamStopped.stream;
  Stream<int> get viewerCount => _viewerCount.stream;
  Stream<int> get messageCount => _messageCount.stream;
  Stream<List<ChatMessage>> get chatHistory => _chatHistory.stream;
  Stream<ChatMessage> get newMessage => _newMessage.stream;
  Stream<String> get messageDeleted => _messageDeleted.stream;
  Stream<String> get socketError => _socketError.stream;

  bool get isConnected => _socket?.connected ?? false;

  /// Поднимает соединение. Идемпотентно: повторные вызовы при уже
  /// открытом или ещё не открывшемся сокете — no-op (возвращают тот же
  /// in-flight Future). Возвращает `false`, если нет токена авторизации.
  Future<bool> connect() async {
    if (_socket?.connected ?? false) {
      _log.connect('already connected, skip');
      return true;
    }
    final inFlight = _connecting;
    if (inFlight != null) {
      _log.connect('connect in-flight, awaiting');
      return inFlight;
    }
    final future = _doConnect();
    _connecting = future;
    try {
      return await future;
    } finally {
      _connecting = null;
    }
  }

  Future<bool> _doConnect() async {
    final token = await getAuthToken();
    if (token == null) {
      _log.warn('no auth token — cannot connect');
      return false;
    }

    _log.connect('opening socket', _host);
    final socket = io.io(
      _host,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    final firstResponse = Completer<bool>();
    void completeOnce(bool ok) {
      if (!firstResponse.isCompleted) firstResponse.complete(ok);
    }

    socket
      ..on('connect', (_) {
        _log.connect('connected, sid=${socket.id}');
        _connection.add(true);
        _emitJoin();
        completeOnce(true);
      })
      ..on('disconnect', (reason) {
        _log.connect('disconnected', reason);
        _connection.add(false);
      })
      ..on('connect_error', (err) {
        _log.error('connect_error', err);
        completeOnce(false);
      })
      ..on('reconnect_attempt', (n) {
        _log.connect('reconnect_attempt', n);
      })
      ..on('streamStarted', (data) {
        _log.event('streamStarted', data);
        if (data is Map) {
          final payload = Map<String, dynamic>.from(data);
          _streamStarted.add(LiveStreamInfo.fromJson(payload));
          // Бэк присылает актуальный viewerCount в том же payload —
          // старый клиент его читал. Без этого счётчик висит на 0 до
          // первого viewerCountUpdate.
          final v = payload['viewerCount'];
          if (v != null) {
            _viewerCount.add(v is int ? v : int.tryParse('$v') ?? 0);
          }
        }
      })
      ..on('streamStopped', (_) {
        _log.event('streamStopped');
        _streamStopped.add(null);
      })
      ..on('viewerCountUpdate', (data) {
        final v = (data is Map ? data['viewerCount'] : null) ?? 0;
        final parsed = v is int ? v : int.tryParse('$v') ?? 0;
        _log.event('viewerCountUpdate', parsed);
        _viewerCount.add(parsed);
      })
      ..on('messageCountUpdate', (data) {
        final v = (data is Map ? data['messageCount'] : null) ?? 0;
        final parsed = v is int ? v : int.tryParse('$v') ?? 0;
        _log.event('messageCountUpdate', parsed);
        _messageCount.add(parsed);
      })
      ..on('chatHistory', (data) {
        if (data is List) {
          final list = data
              .whereType<Map>()
              .map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          _log.event('chatHistory', 'count=${list.length}');
          _chatHistory.add(list);
        }
      })
      ..on('newMessage', (data) {
        if (data is Map) {
          final msg =
              ChatMessage.fromJson(Map<String, dynamic>.from(data));
          _log.event('newMessage', '${msg.fullName}: ${msg.message}');
          _newMessage.add(msg);
        }
      })
      ..on('messageDeleted', (data) {
        final id = (data is Map ? data['messageId'] : null)?.toString();
        if (id != null) {
          _log.event('messageDeleted', id);
          _messageDeleted.add(id);
        }
      })
      ..on('error', (data) {
        final msg = (data is Map ? data['message'] : null)?.toString() ?? '';
        _log.error('socket error event', msg);
        _socketError.add(msg);
      });

    _socket = socket;
    socket.connect();
    // Держим in-flight Future до фактического connect / connect_error,
    // чтобы параллельные вызовы connect() не открывали второй сокет.
    return firstResponse.future
        .timeout(const Duration(seconds: 10), onTimeout: () {
      _log.warn('connect timeout — keeping socket, future calls will retry');
      return false;
    });
  }

  void _emitJoin() {
    final s = _socket;
    if (s == null || !s.connected) return;
    _log.emit('joinStream');
    s.emit('joinStream');
  }

  /// Повторно дёргает `joinStream`, чтобы попросить бэк прислать актуальный
  /// `streamStarted` (если стрим уже идёт). Используется поллингом.
  void requestStreamStatus() {
    if (!isConnected) {
      _log.poll('requestStreamStatus skipped — not connected');
      return;
    }
    _emitJoin();
  }

  void sendMessage(String text) {
    final s = _socket;
    if (s == null || !s.connected) {
      _log.warn('sendMessage skipped — not connected');
      return;
    }
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _log.emit('sendMessage', trimmed);
    s.emit('sendMessage', {'message': trimmed});
  }

  Future<void> disconnect() async {
    _log.connect('manual disconnect');
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _connection.add(false);
  }

  void dispose() {
    disconnect();
    _connection.close();
    _streamStarted.close();
    _streamStopped.close();
    _viewerCount.close();
    _messageCount.close();
    _chatHistory.close();
    _newMessage.close();
    _messageDeleted.close();
    _socketError.close();
  }
}
