import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../auth/login_screen.dart';
import 'settings_screen.dart';
import 'help_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryColor, width: 2),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'Guest User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'Not logged in',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user?.role.toUpperCase() ?? 'USER',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),

            _buildProfileMenu(
              Icons.person_outline,
              'Edit Profile',
              () => _editProfile(context),
            ),
            _buildProfileMenu(
              Icons.settings_outlined,
              'Settings',
              () => _openSettings(context),
            ),
            _buildProfileMenu(
              Icons.help_outline,
              'Help & Support',
              () => _openHelp(context),
            ),

            const SizedBox(height: 40),
            CustomButton(
              text: 'Log Out',
              isOutlined: true,
              onPressed: () async {
                await authProvider.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.textDark),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  void _editProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void _openHelp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HelpScreen()),
    );
  }
}
