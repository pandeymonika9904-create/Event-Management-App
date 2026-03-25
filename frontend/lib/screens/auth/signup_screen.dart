import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../home/home_screen.dart';
import '../organizer/organizer_dashboard_screen.dart';
import '../admin/admin_dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'User';

  void _signup() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
      role: _selectedRole,
    );

    if (authProvider.isAuthenticated && mounted) {
      final role = authProvider.user?.role ?? 'User';
      Widget nextScreen = const HomeScreen();
      
      if (role == 'Admin' || role == 'SuperAdmin') {
        nextScreen = const AdminDashboardScreen();
      } else if (role == 'Organizer') {
        nextScreen = const OrganizerDashboardScreen();
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => nextScreen),
        (route) => false,
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textLight,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Join the premium event community',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 40),

                // Glassmorphism form
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
                        controller: _nameController,
                        hintText: 'Full Name',
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 24),
                      
                      // Role Selector
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0x11FFFFFF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0x33FFFFFF), width: 1),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Theme(
                                data: ThemeData(unselectedWidgetColor: AppTheme.textMuted),
                                child: RadioListTile<String>(
                                  title: const Text(
                                    'User',
                                    style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold),
                                  ),
                                  value: 'User',
                                  groupValue: _selectedRole,
                                  activeColor: AppTheme.secondaryColor,
                                  contentPadding: EdgeInsets.zero,
                                  onChanged: (val) {
                                    setState(() { _selectedRole = val!; });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Theme(
                                data: ThemeData(unselectedWidgetColor: AppTheme.textMuted),
                                child: RadioListTile<String>(
                                  title: const Text(
                                    'Organizer',
                                    style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold),
                                  ),
                                  value: 'Organizer',
                                  groupValue: _selectedRole,
                                  activeColor: AppTheme.secondaryColor,
                                  contentPadding: EdgeInsets.zero,
                                  onChanged: (val) {
                                    setState(() { _selectedRole = val!; });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      CustomButton(
                        text: 'Sign Up',
                        icon: Icons.person_add_alt_1_rounded,
                        onPressed: _signup,
                        isLoading: authProvider.isLoading,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Log In',
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
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
