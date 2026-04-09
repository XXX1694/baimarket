import 'package:flutter/material.dart';
import 'streams_avatar_item.dart';

class StreamInfo {
  const StreamInfo({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.description,
  });
  final String id;
  final String imageUrl;
  final String name;
  final String description;
}

class StreamsAvatarList extends StatelessWidget {
  const StreamsAvatarList({
    super.key,
    required this.streams,
    required this.activeId,
    required this.onSelect,
  });

  final List<StreamInfo> streams;
  final String activeId;
  final ValueChanged<StreamInfo> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: streams.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final stream = streams[index];
          return StreamsAvatarItem(
            imageUrl: stream.imageUrl,
            name: stream.name,
            isActive: stream.id == activeId,
            onTap: () => onSelect(stream),
          );
        },
      ),
    );
  }
}
