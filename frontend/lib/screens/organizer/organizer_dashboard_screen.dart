import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../../utils/mock_data.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import 'package:provider/provider.dart';
import '../auth/login_screen.dart';
import 'create_event_screen.dart';
import 'qr_scanner_screen.dart';
import '../../widgets/event_card.dart';

class OrganizerDashboardScreen extends StatefulWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  State<OrganizerDashboardScreen> createState() => _OrganizerDashboardScreenState();
}

class _OrganizerDashboardScreenState extends State<OrganizerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<EventProvider>().fetchOrganizerEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final stats = MockData.getMockOrganizerStats();
    final eventProvider = context.watch<EventProvider>();
    final myEvents = eventProvider.events;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Organizer Dashboard', style: TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold)),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textLight),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildStatCard(
                      'Total Events',
                      myEvents.length.toString(),
                      Icons.event_available_rounded,
                      Colors.blueAccent,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      'Tickets Sold',
                      (stats['totalTicketsSold'] ?? 0).toString(),
                      Icons.confirmation_number_rounded,
                      Colors.orangeAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildRevenueCard(stats),
                const SizedBox(height: 40),
                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textLight),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Create New Event',
                  icon: Icons.add_circle_outline_rounded,
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateEventScreen()),
                    );
                    if (result == true && context.mounted) {
                      context.read<EventProvider>().fetchOrganizerEvents();
                    }
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Scan Tickets (Entry)',
                  icon: Icons.qr_code_scanner_rounded,
                  isOutlined: true,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                    );
                  },
                ),
                const SizedBox(height: 40),
                const Text(
                  'My Events & Status',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textLight),
                ),
                const SizedBox(height: 20),
                if (eventProvider.isLoading)
                  const Center(child: CircularProgressIndicator(color: AppTheme.secondaryColor))
                else if (myEvents.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        children: const [
                          Icon(Icons.event_note, size: 60, color: AppTheme.textMuted),
                          SizedBox(height: 16),
                          Text('You have not created any events yet.', style: TextStyle(color: AppTheme.textMuted)),
                        ],
                      ),
                    ),
                  )
                else
                  ...myEvents.map((event) {
                    Color statusColor = Colors.orangeAccent;
                    if (event.status == 'Approved') statusColor = Colors.greenAccent;
                    if (event.status == 'Rejected') statusColor = Colors.redAccent;
                    
                    return Column(
                      children: [
                        EventCard(event: event),
                        Container(
                          margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            border: Border.all(color: statusColor.withOpacity(0.5)),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Moderation Status:', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                              Text(event.status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
              ],
            ),
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
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueCard(Map<String, dynamic> stats) {
    final revenue = stats['totalRevenue'] ?? 0;
    final revenueFormatted =
        '₹${revenue.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        gradient: const LinearGradient(
          colors: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE94057).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Revenue',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('+12.5%', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            revenueFormatted,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Last Month',
            style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${((stats['revenueLastMonth'] ?? 0) / 1000).toStringAsFixed(1)}k',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
