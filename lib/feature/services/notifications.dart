import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../common/app_module.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin notification =
      getIt<FlutterLocalNotificationsPlugin>();

  static bool isNotifShown = false;

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    Uint8List? largeIcon,
    Uint8List? bigPicture,
  }) async {
    if (!isNotifShown) {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        body ?? '',
        htmlFormatBigText: true,
        contentTitle: title,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'channel_id 101',
        'channelName Pogs',
        channelDescription: 'channel descriptions Sound',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigTextStyleInformation,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('notification_sound'),
        // sound: const UriAndroidNotificationSound(
        //   "assets/notification/notification_sound.mp3",
        // ),
        ticker: 'ticker',
      );

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await notification.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );

      isNotifShown = true;
    }
  }
}
