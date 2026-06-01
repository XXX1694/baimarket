class ChatMessage {
  final String id;
  final String message;
  final String userId;
  final String fullName;
  final String? avatarUrl;
  final bool isDeleted;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.message,
    required this.userId,
    required this.fullName,
    required this.avatarUrl,
    required this.isDeleted,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'].toString(),
      message: (json['message'] ?? '') as String,
      userId: (json['userId'] ?? '').toString(),
      fullName: (json['fullName'] ?? '') as String,
      avatarUrl: json['avatarUrl'] as String?,
      isDeleted: (json['isDeleted'] ?? false) as bool,
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  ChatMessage copyWith({bool? isDeleted}) => ChatMessage(
        id: id,
        message: message,
        userId: userId,
        fullName: fullName,
        avatarUrl: avatarUrl,
        isDeleted: isDeleted ?? this.isDeleted,
        timestamp: timestamp,
      );
}
