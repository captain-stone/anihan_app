import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationModule {
  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      FlutterLocalNotificationsPlugin();

  static Future<FlutterLocalNotificationsPlugin> initializeNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const settingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: settingsAndroid,
      iOS: settingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    return flutterLocalNotificationsPlugin;
  }
}
