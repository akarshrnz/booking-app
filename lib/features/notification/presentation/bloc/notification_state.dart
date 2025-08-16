
import 'package:equatable/equatable.dart';
import 'package:innerspace_booking_app/features/notification/domain/entities/notification.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];


}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}
class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  const NotificationLoaded(this.notifications);
    @override
  List<Object> get props => [notifications];
}
class NotificationError extends NotificationState {}