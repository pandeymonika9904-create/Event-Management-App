import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../home/home_screen.dart';
import '../organizer/organizer_dashboard_screen.dart';
import '../admin/admin_dashboard_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (authProvider.isAuthenticated && mounted) {
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
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Logo / Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.event_seat_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Welcome Texts
                  const Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textLight,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Log in to discover and book exclusive events\naround your area.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textMuted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Glassmorphism Card for inputs
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0x22FFFFFF), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Email Address',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppTheme.secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Log In',
                          icon: Icons.login_rounded,
                          onPressed: _login,
                          isLoading: authProvider.isLoading,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account? ',
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
