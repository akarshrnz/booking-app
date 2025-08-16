import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<
    void
  >
  init() async {
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(
      android: android,
    );
    await _plugin.initialize(
      settings,
    );
  }

  Future<
    void
  >
  show(
    String title,
    String body,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(
      android: androidDetails,
    );
    await _plugin.show(
      0,
      title,
      body,
      details,
    );
  }
}
