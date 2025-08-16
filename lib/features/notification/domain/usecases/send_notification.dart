
import 'package:innerspace_booking_app/features/notification/domain/entities/notification.dart';
import 'package:innerspace_booking_app/features/notification/domain/repositories/notification_repository.dart';

class SendNotification {
  final NotificationRepository repository;
  SendNotification(this.repository);

  Future<void> call(NotificationEntity notification, String userId) {
    return repository.sendNotification(notification, userId);
  }
}