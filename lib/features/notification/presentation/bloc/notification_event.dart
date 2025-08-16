
import 'package:equatable/equatable.dart';
import 'package:innerspace_booking_app/features/notification/domain/entities/notification.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}
 
class StartListeningNotifications extends NotificationEvent {
  final String userId;
  const StartListeningNotifications(this.userId);

   @override
  List<Object> get props => [userId];
}


class AddNotification extends NotificationEvent {
  final NotificationEntity notification;
  final String userId;
  const AddNotification(this.notification, this.userId);
 @override
  List<Object> get props => [userId];}