import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mad_group_project/firebase_options.dart';
import 'package:mad_group_project/welcome.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Correct class name.

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(MaterialApp(home: SignInSelection()));
  runApp(MaterialApp(home: Welcome()));
}
