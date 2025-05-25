import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/core/services/local_notification_service.dart';
// import 'package:listify/core/services/notification_service.dart';
import './firebase_options.dart';
import 'router/app_router.dart';

// final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// Main function to initialize the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized before running async code
  await Firebase.initializeApp(
    // Initialize Firebase with platform-specific options
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await NotificationService.instance.initialize(); // Initialize the notification service
  await LocalNotificationService.initialize();
  runApp(
    ProviderScope(child: MyApp()),
  ); // Wrap the app with Riverpod's ProviderScope for state management
}

// Main app widget
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use FutureBuilder to wait for the router to be created
    return FutureBuilder<GoRouter>(
      future: AppRouter.createRouter(ref), // Create the router asynchronously
      builder: (context, snapshot) {
        // Show a loading indicator while the router is being created
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        // Once the router is ready, use it in the MaterialApp
        final router = snapshot.data!;
        return MaterialApp.router(
          routerConfig: router, // Set the router configuration
          title: 'Listify', // App title
        );
      },
    );
  }
}
