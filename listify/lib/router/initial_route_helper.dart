import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialRouteHelper {
  // Use FlutterSecureStorage for mobile and desktop
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<String> getInitialRoute(String homeRoute, String welcomeRoute) async {
    if (kIsWeb) {
      // Use SharedPreferences for web
      final prefs = await SharedPreferences.getInstance();
      final isShowWelcome = prefs.getBool('isShowWelcome') ?? true;
      if (isShowWelcome) {
        await prefs.setBool('isShowWelcome', false);
        return welcomeRoute;
      }
    } else {
      // Use FlutterSecureStorage for mobile/desktop
      final isShowWelcome = await _secureStorage.read(key: 'isShowWelcome');
      if (isShowWelcome == null || isShowWelcome == 'true') {
        await _secureStorage.write(key: 'isShowWelcome', value: 'false');
        return welcomeRoute;
      }
    }
    return homeRoute;
  }
}