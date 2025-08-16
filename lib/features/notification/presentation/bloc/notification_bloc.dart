import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace_booking_app/core/notification_service.dart';
import 'package:innerspace_booking_app/features/notification/domain/usecases/get_notifications.dart';
import 'package:innerspace_booking_app/features/notification/domain/usecases/send_notification.dart';
import 'package:innerspace_booking_app/features/notification/presentation/bloc/notification_event.dart';
import 'package:innerspace_booking_app/features/notification/presentation/bloc/notification_state.dart';

import '../../../../core/local_notification_service.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications getNotifications;
  final SendNotification sendNotification;
  final LocalNotificationService localNotificationService;

  NotificationBloc({
    required this.getNotifications,
    required this.sendNotification,
    required this.localNotificationService,
  }) : super(NotificationInitial()) {
    on<StartListeningNotifications>((event, emit) async {
      emit(NotificationLoading());
      await emit.forEach(
        getNotifications(event.userId),
        onData: (notifications) {
       
          return NotificationLoaded(notifications);
        },
        onError: (_, __) => NotificationError(),
      );
    });

    on<AddNotification>((event, emit) async {
        final NotificationService notificationService = NotificationService();
        print("notification called 1-------------");
         sendNotification(event.notification, event.userId);

      if (event.notification.title.isNotEmpty) {
        print("notification called -------------");
        final latest=event.notification;
            notificationService.showNotification(title:  latest.title,body:  latest.body,);
          }
    
    });
  }
}
