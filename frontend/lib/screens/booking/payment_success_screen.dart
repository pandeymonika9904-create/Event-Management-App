import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../home/home_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String bookingId;

  const PaymentSuccessScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppTheme.secondaryColor,
                  size: 100,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your ticket has been booked successfully.\nYou can view your QR code in My Bookings.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomButton(
                  text: 'Go to Home',
                  icon: Icons.home_rounded,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
