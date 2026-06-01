part of 'live_cubit.dart';

class LiveState extends Equatable {
  final bool isConnected;
  final bool isStreamActive;
  final LiveStreamInfo? streamInfo;
  final int viewerCount;
  final int messageCount;
  final List<ChatMessage> chatMessages;
  final String? lastError;

  const LiveState({
    required this.isConnected,
    required this.isStreamActive,
    required this.streamInfo,
    required this.viewerCount,
    required this.messageCount,
    required this.chatMessages,
    required this.lastError,
  });

  const LiveState.initial()
      : isConnected = false,
        isStreamActive = false,
        streamInfo = null,
        viewerCount = 0,
        messageCount = 0,
        chatMessages = const [],
        lastError = null;

  LiveState copyWith({
    bool? isConnected,
    bool? isStreamActive,
    LiveStreamInfo? streamInfo,
    bool clearStreamInfo = false,
    int? viewerCount,
    int? messageCount,
    List<ChatMessage>? chatMessages,
    String? lastError,
  }) {
    return LiveState(
      isConnected: isConnected ?? this.isConnected,
      isStreamActive: isStreamActive ?? this.isStreamActive,
      streamInfo: clearStreamInfo ? null : (streamInfo ?? this.streamInfo),
      viewerCount: viewerCount ?? this.viewerCount,
      messageCount: messageCount ?? this.messageCount,
      chatMessages: chatMessages ?? this.chatMessages,
      lastError: lastError ?? this.lastError,
    );
  }

  // Сохраняем legacy-имя для обратной совместимости импортов.
  // ignore: non_constant_identifier_names
  static LiveState get LiveInitial => const LiveState.initial();

  @override
  List<Object?> get props => [
        isConnected,
        isStreamActive,
        streamInfo?.videoId,
        viewerCount,
        messageCount,
        chatMessages,
        lastError,
      ];
}

/// Совместимость со старым кодом, если где-то использовался класс `LiveInitial`.
class LiveInitial extends LiveState {
  const LiveInitial() : super.initial();
}
