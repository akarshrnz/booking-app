
import 'package:innerspace_booking_app/features/notification/domain/entities/notification.dart';

abstract class NotificationRepository {
  Stream<List<NotificationEntity>> listenToNotifications(String userId);
  Future<void> sendNotification(NotificationEntity notification, String userId);
}