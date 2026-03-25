import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../core/constants.dart';
import '../utils/mock_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;
  String _error = '';

  List<Event> get events => _events;
  List<Event> get trendingEvents => _events.where((e) => e.isTrending).toList();
  bool get isLoading => _isLoading;
  String get error => _error;

  // Initialize with mock data
  EventProvider() {
    _events = MockData.getMockEvents();
  }

  Future<void> fetchEvents({String keyword = '', String category = ''}) async {
    _isLoading = true;
    notifyListeners();

    try {
      String query = '?';
      if (keyword.isNotEmpty) query += 'keyword=$keyword&';
      if (category.isNotEmpty && category != 'All') query += 'category=$category';

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/events$query'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _events = data.map((json) => Event.fromJson(json)).toList();
        _error = '';
      } else {
        _error = 'Failed to load events. Showing sample data.';
        _events = MockData.getMockEvents();
      }
    } catch (e) {
      _error = 'Network error. Showing sample data: $e';
      _events = MockData.getMockEvents();
    }

    _isLoading = false;
    notifyListeners();
  }
  Future<void> fetchOrganizerEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(AppConstants.tokenKey);

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/events/organizer/my-events'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _events = data.map((json) => Event.fromJson(json)).toList();
        _error = '';
      } else {
        _error = 'Failed to load organizer events.';
        _events = [];
      }
    } catch (e) {
      _error = 'Network error: $e';
      _events = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createEvent(Map<String, dynamic> eventData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(AppConstants.tokenKey);

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/events'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(eventData),
      );

      if (response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        try {
          final data = jsonDecode(response.body);
          _error = data['message'] ?? 'Failed to create event.';
        } catch (_) {
          _error = 'Failed to create event. Status: ${response.statusCode}';
        }
      }
    } catch (e) {
      _error = 'Network error: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
