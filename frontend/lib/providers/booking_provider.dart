import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking.dart';
import '../core/constants.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _myBookings = [];
  bool _isLoading = false;
  String _error = '';

  List<Booking> get myBookings => _myBookings;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(AppConstants.userKey)) return null;
    final userData = jsonDecode(prefs.getString(AppConstants.userKey)!);
    return userData['token'];
  }

  Future<Map<String, dynamic>?> createBooking(String eventId, String ticketType, int quantity) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/bookings'),
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'eventId': eventId,
          'ticketType': ticketType,
          'quantity': quantity
        }),
      );

      if (response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        final data = jsonDecode(response.body);
        return {
          'booking': Booking.fromJson(data['booking']),
          'orderId': data['orderId'],
          'amount': data['amount'],
        };
      } else {
        _error = jsonDecode(response.body)['message'] ?? 'Booking failed';
      }
    } catch (e) {
      _error = 'Network error: $e';
    }

    _isLoading = false;
    notifyListeners();
    return null;
  }
  Future<bool> verifyPayment(String orderId, String paymentId, String signature, String bookingId) async {
    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/bookings/verify'),
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'razorpay_order_id': orderId,
          'razorpay_payment_id': paymentId,
          'razorpay_signature': signature,
          'bookingId': bookingId,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _error = jsonDecode(response.body)['message'] ?? 'Payment verification failed';
        return false;
      }
    } catch (e) {
      _error = 'Network error: $e';
      return false;
    }
  }


  Future<void> fetchMyBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/bookings/mybookings'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _myBookings = data.map((json) => Booking.fromJson(json)).toList();
        _error = '';
      } else {
        _error = 'Failed to load bookings';
      }
    } catch (e) {
      _error = 'Network error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
