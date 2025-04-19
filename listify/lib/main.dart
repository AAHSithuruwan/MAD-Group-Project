import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router/app_router.dart';


Future<void> main() async {

  // Ensures Flutter is initialized before async code
  WidgetsFlutterBinding.ensureInitialized(); 

  // Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  // Initialize the router
  final router = await AppRouter.createRouter(); // Create the router asynchronously

  // Run the app with the initialized router
    runApp(MyApp(router: router));
}



class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router, // Use the initialized router
      title: 'Go Router Example',
    );
  }
}