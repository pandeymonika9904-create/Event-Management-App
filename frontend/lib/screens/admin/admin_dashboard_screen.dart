import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/admin_provider.dart';
import '../auth/login_screen.dart';
import 'admin_organizers_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().fetchAdminStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Consumer<AdminProvider>(
            builder: (context, adminData, child) {
              if (adminData.isLoading) {
                return const Center(child: CircularProgressIndicator(color: AppTheme.secondaryColor));
              }

              if (adminData.error.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
                      const SizedBox(height: 16),
                      Text(adminData.error, style: const TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () => context.read<AdminProvider>().fetchAdminStats(),
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                );
              }

              final stats = adminData.stats;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'System Overview',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textLight),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildStatCard('Users', (stats['usersCount'] ?? 0).toString(), Icons.group_rounded, Colors.blueAccent),
                        const SizedBox(width: 16),
                        _buildStatCard('Events', (stats['eventsCount'] ?? 0).toString(), Icons.event_rounded, Colors.orangeAccent),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildStatCard('Bookings', (stats['bookingsCount'] ?? 0).toString(), Icons.confirmation_num_rounded, Colors.purpleAccent),
                        const SizedBox(width: 16),
                        _buildStatCard('Revenue (₹)', (stats['totalRevenue'] ?? 0).toString(), Icons.currency_rupee_rounded, Colors.greenAccent),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Moderation',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textLight),
                    ),
                    const SizedBox(height: 20),
                    _buildActionCard(
                      context,
                      'Review Organizers',
                      'Approve or reject organizer KYC',
                      Icons.admin_panel_settings_rounded,
                      Colors.pinkAccent,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminOrganizersScreen()),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x33FFFFFF), width: 1),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 20),
            Text(
              value,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.textLight),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x33FFFFFF), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textLight)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: AppTheme.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}
