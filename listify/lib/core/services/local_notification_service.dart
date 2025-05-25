import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/main.dart'; 

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        final context = rootNavigatorKey.currentContext;
        if (context != null) {
          final payload = details.payload;
          if (payload != null) {
            final data = jsonDecode(payload);
            GoRouter.of(context).push(
              '/notification',
              extra: {
                'title': data['title'],
                'body': data['body'],
                'data': data['data'],
              },
            );
          } else {
            GoRouter.of(context).push('/notification');
          }
        }
      },
    );
  }

  static Future<void> showNotification(
    String title,
    String body, {
    Map<String, dynamic>? data,
  }) async {
    final String largeIconPath = await _copyAssetImageToFile('assets/appIcons/transparent_lg.png');

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'General Notifications',
      channelDescription: 'Used for general notifications',
      importance: Importance.max,
      priority: Priority.high,
      largeIcon: FilePathAndroidBitmap(largeIconPath), 
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    final payload = jsonEncode({
      'title': title,
      'body': body,
      'data': data ?? {},
    });

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  // helper function to copy asset image to a temporary file
  static Future<String> _copyAssetImageToFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/notification_image.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }
}