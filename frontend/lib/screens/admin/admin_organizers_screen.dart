import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/admin_provider.dart';

class AdminOrganizersScreen extends StatefulWidget {
  const AdminOrganizersScreen({super.key});

  @override
  State<AdminOrganizersScreen> createState() => _AdminOrganizersScreenState();
}

class _AdminOrganizersScreenState extends State<AdminOrganizersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().fetchOrganizers();
    });
  }

  void _updateStatus(String id, String status) async {
    final success = await context.read<AdminProvider>().updateOrganizerStatus(id, status);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Status updated to $status' : 'Failed to update status', style: const TextStyle(color: Colors.white)),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Review Organizers', style: TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold)),
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
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Consumer<AdminProvider>(
            builder: (context, adminData, child) {
              if (adminData.isLoading && adminData.organizers.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppTheme.secondaryColor));
              }

              if (adminData.error.isNotEmpty && adminData.organizers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
                      const SizedBox(height: 16),
                      Text(adminData.error, style: const TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () => context.read<AdminProvider>().fetchOrganizers(),
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                );
              }

              final organizers = adminData.organizers;

              if (organizers.isEmpty) {
                return const Center(child: Text('No organizers found.', style: TextStyle(color: Colors.white70)));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: organizers.length,
                itemBuilder: (context, index) {
                  final org = organizers[index];
                  final status = org['kycStatus'] ?? 'Pending';
                  
                  Color statusColor;
                  if (status == 'Approved') {
                    statusColor = Colors.greenAccent;
                  } else if (status == 'Rejected') statusColor = Colors.redAccent;
                  else statusColor = Colors.orangeAccent;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0x33FFFFFF), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                org['name'] ?? 'Unknown',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textLight),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor.withOpacity(0.5)),
                              ),
                              child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(org['email'] ?? '', style: const TextStyle(color: AppTheme.textMuted, fontSize: 14)),
                        const SizedBox(height: 20),
                        if (status == 'Pending')
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _updateStatus(org['_id'], 'Approved'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent.withOpacity(0.2),
                                    foregroundColor: Colors.greenAccent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Approve'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _updateStatus(org['_id'], 'Rejected'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent.withOpacity(0.2),
                                    foregroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Reject'),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
