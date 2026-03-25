import 'package:flutter/foundation.dart';

class AppConstants {
  static String get baseUrl {
    // Production Vercel URL
    return 'https://backend-kohl-chi-bkebo68vzc.vercel.app/api';
  }

  static const String tokenKey = 'jwt_token';
  static const String userKey = 'user_data';
}
