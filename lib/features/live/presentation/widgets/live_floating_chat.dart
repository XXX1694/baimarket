import 'package:flutter/material.dart';

import '../../data/models/chat_message.dart';

/// Плавающие сообщения чата без фона-контейнера — как в макете frame 11.
/// Показываются последние [maxVisible] сообщений снизу-вверх.
class LiveFloatingChat extends StatelessWidget {
  const LiveFloatingChat({
    super.key,
    required this.messages,
    this.maxVisible = 3,
  });
  final List<ChatMessage> messages;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) return const SizedBox.shrink();
    final tail = messages.length > maxVisible
        ? messages.sublist(messages.length - maxVisible)
        : messages;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final m in tail) _ChatRow(message: m),
      ],
    );
  }
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({required this.message});
  final ChatMessage message;

  String get _initials {
    final n = message.fullName.trim();
    if (n.isEmpty) return '?';
    return n
        .split(RegExp(r'\s+'))
        .take(2)
        .map((p) => p.isEmpty ? '' : p[0])
        .join()
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 7, 15, 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38.4,
            height: 38.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
            ),
            alignment: Alignment.center,
            child: message.avatarUrl != null && message.avatarUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      message.avatarUrl!,
                      width: 38.4,
                      height: 38.4,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _Initials(text: _initials),
                    ),
                  )
                : _Initials(text: _initials),
          ),
          const SizedBox(width: 11.6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  message.isDeleted ? 'Сообщение удалено' : message.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: message.isDeleted
                        ? Colors.redAccent
                        : Colors.white.withValues(alpha: 0.8),
                    fontStyle: message.isDeleted
                        ? FontStyle.italic
                        : FontStyle.normal,
                    height: 1.2,
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

class _Initials extends StatelessWidget {
  const _Initials({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Gilroy',
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}
