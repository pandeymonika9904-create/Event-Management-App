import 'package:flutter/foundation.dart';

class AppConstants {
  static String get baseUrl {
    // For Production (after Render deployment):
    // return 'https://your-render-app-url.onrender.com/api';
    
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }
    // Use your PC's LAN IP for physical devices
    return 'http://192.168.212.188:5000/api';
  }

  static const String tokenKey = 'jwt_token';
  static const String userKey = 'user_data';
}
