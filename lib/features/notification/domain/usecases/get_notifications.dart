
import 'package:dartz/dartz.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/notification/domain/entities/notification.dart';
import 'package:innerspace_booking_app/features/notification/domain/repositories/notification_repository.dart';


class GetNotifications {
  final NotificationRepository repository;
  GetNotifications(this.repository);

  Stream<List<NotificationEntity>> call(String userId) {
    return repository.listenToNotifications(userId);
  }
}