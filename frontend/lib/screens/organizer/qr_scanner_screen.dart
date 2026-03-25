import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isScanning = true;

  Future<void> _handleScan(String? token) async {
    if (token == null || !_isScanning) return;

    setState(() => _isScanning = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppTheme.secondaryColor),
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey(AppConstants.userKey)) {
        Navigator.pop(context);
        _showResultDialog('Error', 'Not Authenticated', Colors.redAccent, Icons.error_outline_rounded);
        return;
      }
      
      final userData = jsonDecode(prefs.getString(AppConstants.userKey)!);
      final jwt = userData['token'];

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/qr/scan'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonEncode({'qrToken': token}),
      );

      Navigator.pop(context); // close loader

      if (response.statusCode == 200) {
        _showResultDialog(
          'Success',
          'Ticket verified & Checked in!',
          Colors.greenAccent,
          Icons.check_circle_outline_rounded
        );
      } else {
        final message = jsonDecode(response.body)['message'] ?? 'Invalid Ticket';
        _showResultDialog('Failed', message, Colors.redAccent, Icons.cancel_outlined);
      }
    } catch (e) {
      Navigator.pop(context);
      _showResultDialog('Error', 'Network error. Try again.', Colors.orangeAccent, Icons.wifi_off_rounded);
    }
  }

  void _showResultDialog(String title, String message, Color color, IconData icon) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0x33FFFFFF), width: 1),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 64),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textLight, fontSize: 16),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) setState(() => _isScanning = true);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Scan Next Ticket', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Scan Tickets', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                _handleScan(barcodes.first.rawValue);
              }
            },
          ),
          // Scanner Overlay effect
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.secondaryColor, width: 3),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: AppTheme.secondaryColor.withOpacity(0.5), blurRadius: 20, spreadRadius: 2),
                  ]
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        color: AppTheme.secondaryColor,
                        // Could animate this line up and down
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Text(
              'Align QR code within the frame to check in',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          )
        ],
      ),
    );
  }
}
