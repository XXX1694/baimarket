import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_pallete.dart';
import '../../data/models/chat_message.dart';

/// Единственный chat-input для лайв-стрима + лента сообщений.
///
/// Высота скейлится от размера экрана, чтобы не съедать пол-экрана на
/// маленьких устройствах. При открытой клавиатуре панель ужимается.
class LiveChatPanel extends StatefulWidget {
  const LiveChatPanel({
    super.key,
    required this.messages,
    required this.canChat,
    required this.onSend,
  });

  final List<ChatMessage> messages;
  final bool canChat;
  final ValueChanged<String> onSend;

  @override
  State<LiveChatPanel> createState() => _LiveChatPanelState();
}

class _LiveChatPanelState extends State<LiveChatPanel> {
  final _input = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _focus = FocusNode();

  @override
  void didUpdateWidget(covariant LiveChatPanel old) {
    super.didUpdateWidget(old);
    if (widget.messages.length != old.messages.length) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _scrollCtrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _input.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final keyboardOpen = mq.viewInsets.bottom > 0;
    // Адаптивная высота: 32% экрана без клавиатуры, 26% с ней.
    final maxHeight = mq.size.height * (keyboardOpen ? 0.26 : 0.32);
    final height = maxHeight.clamp(180.0, 320.0);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: widget.messages.isEmpty
                  ? _EmptyChatHint(canChat: widget.canChat)
                  : ListView.builder(
                      controller: _scrollCtrl,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      itemCount: widget.messages.length,
                      itemBuilder: (context, i) =>
                          _ChatRow(message: widget.messages[i]),
                    ),
            ),
            const Divider(
              height: 1,
              thickness: 0.5,
              color: Color(0x33FFFFFF),
            ),
            _InputRow(
              controller: _input,
              focusNode: _focus,
              enabled: widget.canChat,
              onSend: _send,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChatHint extends StatelessWidget {
  const _EmptyChatHint({required this.canChat});
  final bool canChat;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          canChat
              ? 'Сообщений пока нет. Будьте первым!'
              : 'Чат будет доступен во время стрима',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white60,
            fontFamily: 'Gilroy',
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.onSend,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              onSubmitted: (_) => onSend(),
              textInputAction: TextInputAction.send,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Gilroy',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: enabled
                    ? 'Введите сообщение...'
                    : 'Чат недоступен',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontFamily: 'Gilroy',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.10),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.45),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size(40, 40),
            onPressed: enabled ? onSend : null,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: enabled
                    ? mainColorLight
                    : Colors.white.withValues(alpha: 0.15),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({required this.message});
  final ChatMessage message;

  String get _initials {
    final name = message.fullName.trim();
    if (name.isEmpty) return '?';
    return name
        .split(RegExp(r'\s+'))
        .take(2)
        .map((p) => p.isEmpty ? '' : p[0])
        .join()
        .toUpperCase();
  }

  String get _time {
    final h = message.timestamp.hour.toString().padLeft(2, '0');
    final m = message.timestamp.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Text(
              _initials,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        message.fullName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _time,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontFamily: 'Gilroy',
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  message.isDeleted ? 'Сообщение удалено' : message.message,
                  style: TextStyle(
                    color: message.isDeleted
                        ? Colors.redAccent
                        : Colors.white,
                    fontFamily: 'Gilroy',
                    fontStyle: message.isDeleted
                        ? FontStyle.italic
                        : FontStyle.normal,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
