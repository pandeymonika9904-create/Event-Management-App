import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class AdminProvider with ChangeNotifier {
  Map<String, dynamic> _stats = {};
  List<dynamic> _organizers = [];
  bool _isLoading = false;
  String _error = '';

  Map<String, dynamic> get stats => _stats;
  List<dynamic> get organizers => _organizers;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(AppConstants.userKey)) return null;
    final userData = jsonDecode(prefs.getString(AppConstants.userKey)!);
    return userData['token'];
  }

  Future<void> fetchAdminStats() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token');

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/admin/stats'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        _stats = jsonDecode(response.body);
        _error = '';
      } else {
        _error = 'Failed to load stats';
      }
    } catch (e) {
      _error = 'Error loading admin stats';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchOrganizers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token');

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/admin/organizers'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        _organizers = jsonDecode(response.body);
        _error = '';
      } else {
        _error = 'Failed to load organizers';
      }
    } catch (e) {
      _error = 'Error loading organizers';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateOrganizerStatus(String id, String status) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('${AppConstants.baseUrl}/admin/organizer/$id/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status}),
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        // Update local list
        final index = _organizers.indexWhere((org) => org['_id'] == id);
        if (index != -1) {
          _organizers[index]['kycStatus'] = status;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
