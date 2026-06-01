part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationGetting extends NotificationState {}

class NotificationGot extends NotificationState {
  final List<NotificationModel> notifications;
  const NotificationGot({required this.notifications});
}

class NotificationGetError extends NotificationState {}
