import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/streams_app_bar.dart';
import '../widgets/streams_avatar_list.dart';
import '../widgets/streams_live_card.dart';

const _mockStreams = [
  StreamInfo(
    id: '1',
    imageUrl: 'https://picsum.photos/seed/s1/400/600',
    name: 'Irysbala Ikrambay',
    description: 'Автокөлік ойнатамыз!',
  ),
  StreamInfo(
    id: '2',
    imageUrl: 'https://picsum.photos/seed/s2/400/600',
    name: 'Irysbala Ikramba...',
    description: 'Жаңа коллекция!',
  ),
  StreamInfo(
    id: '3',
    imageUrl: 'https://picsum.photos/seed/s3/400/600',
    name: 'Irysbala Ikramba...',
    description: 'Арнайы жеңілдіктер!',
  ),
  StreamInfo(
    id: '4',
    imageUrl: 'https://picsum.photos/seed/s4/400/600',
    name: 'Irysbala Ikramba...',
    description: 'Косметика шолу',
  ),
  StreamInfo(
    id: '5',
    imageUrl: 'https://picsum.photos/seed/s5/400/600',
    name: 'Irysbala Ikramba...',
    description: 'Live Q&A',
  ),
];

class StreamsPage extends StatefulWidget {
  const StreamsPage({super.key});

  @override
  State<StreamsPage> createState() => _StreamsPageState();
}

class _StreamsPageState extends State<StreamsPage> {
  String _activeId = _mockStreams.first.id;

  StreamInfo get _activeStream =>
      _mockStreams.firstWhere((s) => s.id == _activeId);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF111111),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StreamsAppBar(),
              StreamsAvatarList(
                streams: _mockStreams,
                activeId: _activeId,
                onSelect: (stream) => setState(() => _activeId = stream.id),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: StreamsLiveCard(stream: _activeStream),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
