/// Метаданные текущего активного стрима, приходящие в `streamStarted`.
class LiveStreamInfo {
  final String videoId;
  final String channelTitle;
  final String? thumbnailUrl;

  const LiveStreamInfo({
    required this.videoId,
    required this.channelTitle,
    required this.thumbnailUrl,
  });

  factory LiveStreamInfo.fromJson(Map<String, dynamic> json) {
    return LiveStreamInfo(
      videoId: (json['videoId'] ?? '').toString(),
      channelTitle: (json['channelTitle'] ?? '').toString(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }
}
