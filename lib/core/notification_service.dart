import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Method to initialize the notification settings.
  Future<void> initializeNotifications() async {
    // Initialize the notification settings for Android.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Combine settings for all platforms you plan to support.
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Initialize the plugin with the settings.
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // Method to show a local notification with a customizable title and body.
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    // Define the Android-specific notification details.
    try {
      print("notification called  show aclled ---");

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'innerspace_booking_channel', // A unique and descriptive channel ID.
    'Booking Notifications', // The name of the channel.
    channelDescription: 'Notifications for your bookings and appointments.', // Description of the channel.
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  
  // Define the general platform-specific details.
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  
  // Show the notification with a unique ID, title, body, and details.
  await flutterLocalNotificationsPlugin.show(
    0, // The unique ID for the notification.
    title, // The title of the notification passed as an argument.
    body, // The body of the notification passed as an argument.
    platformChannelSpecifics, // The platform-specific details.
    payload: 'item x', // An optional payload.
  );
}  catch (e) {
print("notification called  error");}
  }
}