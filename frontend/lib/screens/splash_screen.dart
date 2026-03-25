import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/theme.dart';
import 'onboarding_screen.dart';
import 'home/home_screen.dart';
import 'organizer/organizer_dashboard_screen.dart';
import 'admin/admin_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animationController.forward();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Force splash delay of 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.tryAutoLogin();

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      final role = authProvider.user?.role ?? 'User';
      Widget nextScreen = const HomeScreen();
      
      if (role == 'Admin' || role == 'SuperAdmin') {
        nextScreen = const AdminDashboardScreen();
      } else if (role == 'Organizer') {
        nextScreen = const OrganizerDashboardScreen();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_available, size: 100, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'EventApp',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover & Book Premium Events',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
