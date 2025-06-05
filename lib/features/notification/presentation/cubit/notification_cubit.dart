import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/notification_services.dart';
import '../../data/models/notification_model.dart';
import '../../domain/repositories/notification_repository.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationCubit({NotificationRepository? notificationRepository})
    : _notificationRepository =
          notificationRepository ?? NotificationServices(),
      super(NotificationInitial()) {
    getNotifications();
  }

  Future<void> getNotifications() async {
    emit(NotificationGetting());
    try {
      List<NotificationModel> notifications =
          await _notificationRepository.getNotification();
      if (notifications.isNotEmpty) {
        emit(NotificationGot(notifications: notifications));
      } else {
        emit(NotificationGetError());
      }
    } catch (e) {
      emit(NotificationGetError());
    }
  }
}
