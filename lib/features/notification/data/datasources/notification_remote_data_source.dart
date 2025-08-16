import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innerspace_booking_app/features/notification/data/model/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Stream<List<NotificationModel>> listenToNotifications(String userId);
  Future<void> sendNotification(NotificationModel notification, String userId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationRemoteDataSourceImpl(this.firestore);

  @override
  Stream<List<NotificationModel>> listenToNotifications(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => NotificationModel.fromMap(doc.data(), doc.id)).toList());
  }

  @override
  Future<void> sendNotification(NotificationModel notification, String userId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notification.id)
        .set(notification.toMap());
  }
}
