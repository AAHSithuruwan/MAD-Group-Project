import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/main.dart'; // Import your navigatorKey

// Background handler for Firebase messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotification(); // Ensure local notifications are set up
  await NotificationService.instance.showNotification(message); // Show the notification when a background message is received
}

// Singleton service for handling notifications
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance; // Firebase Messaging instance for FCM (Firebase Cloud Messaging)
  final _localNotification = FlutterLocalNotificationsPlugin(); // Local notifications plugin instance
  bool _isFlutterLocalNotificationInitialized = false; // Track if local notifications are initialized

  // Initialize notification service
  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); // Register background message handler

    await _requestPermission(); // Request notification permissions from the user
    await _setupMessageHandlers(); // Set up handlers for different message scenarios

    final token = await _messaging.getToken(); // Get and print the FCM token for this device
    print('FCM Token: $token');
  }

  // Request notification permissions from the user
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    print('Permission status: ${settings.authorizationStatus}');
  }

  // Set up local notification channels and initialization
  Future<void> setupFlutterNotification() async {
    if (_isFlutterLocalNotificationInitialized) {
      return; // Already initialized, skip setup
    }

    // Define Android notification channel
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    // Create the notification channel on Android
    await _localNotification
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Android initialization settings
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS initialization settings
    const initializationSettingsDarwin = DarwinInitializationSettings();

    // Combine settings for both platforms
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Initialize the local notifications plugin
    await _localNotification.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Notification tapped: ${details.payload}');

        // Navigate to notifications page when a notification is tapped
        final context = rootNavigatorKey.currentContext;
        if (context != null) {
          GoRouter.of(context).go('/notifications'); // Change route as needed
        }
      },
    );

    _isFlutterLocalNotificationInitialized = true;
  }

  // Show a local notification based on a received FCM message
  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(), // Pass data as payload
      );
    }
  }

  // Set up handlers for foreground, background, and terminated states
  Future<void> _setupMessageHandlers() async {
    // Handle messages when app is in the foreground
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // Handle messages when app is opened from a notification (background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Handle messages when app is launched from a terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  // Handle navigation when a notification is tapped (background/terminated)
  void _handleBackgroundMessage(RemoteMessage message) {
    // Handle the background message when the app is opened from a notification
    print('Background message: ${message.data}');
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      GoRouter.of(context).push('/notifications'); // Change route as needed
    }
  }
}
