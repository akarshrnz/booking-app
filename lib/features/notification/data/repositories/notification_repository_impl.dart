import 'package:innerspace_booking_app/features/notification/data/model/notification_model.dart';
import 'package:innerspace_booking_app/features/notification/domain/entities/notification.dart';

import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<NotificationEntity>> listenToNotifications(String userId) {
    return remoteDataSource.listenToNotifications(userId);
  }

  @override
  Future<void> sendNotification(NotificationEntity notification, String userId) {
    return remoteDataSource.sendNotification(
      NotificationModel(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        timestamp: notification.timestamp,
      ),
      userId,
    );
  }
}
