import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/event_provider.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../booking/checkout_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final event = eventProvider.events.firstWhere((e) => e.id == eventId);

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              Image.network(
                event.bannerImage.isNotEmpty 
                    ? event.bannerImage 
                    : 'https://via.placeholder.com/400x300',
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 350,
                  color: const Color(0xFF1B1B2F),
                  child: const Center(
                    child: Icon(Icons.image_not_supported_outlined, size: 80, color: AppTheme.textMuted),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5)),
                          ),
                          child: Text(
                            event.category,
                            style: const TextStyle(
                              color: AppTheme.secondaryColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        if (event.isTrending)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.orange.withOpacity(0.5)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.local_fire_department_rounded, color: Colors.orangeAccent, size: 18),
                                SizedBox(width: 6),
                                Text('Trending', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textLight,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Date & Time
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0x22FFFFFF), width: 1),
                          ),
                          child: const Icon(Icons.calendar_month_rounded, color: AppTheme.secondaryColor, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('EEEE, MMM dd, yyyy').format(event.date),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textLight),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.time,
                              style: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Location
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0x22FFFFFF), width: 1),
                          ),
                          child: const Icon(Icons.location_on_rounded, color: AppTheme.accentColor, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Location',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textLight),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                event.location,
                                style: const TextStyle(color: AppTheme.textMuted, fontSize: 14, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    
                    // About
                    const Text(
                      'About Event',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textLight),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      event.description,
                      style: const TextStyle(
                        color: AppTheme.textMuted, 
                        height: 1.6, 
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 100), // padding for bottom bar
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B2F).withOpacity(0.95),
          border: const Border(top: BorderSide(color: Color(0x33FFFFFF), width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(0, -10),
              blurRadius: 20,
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Price starts from', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      event.tickets.isNotEmpty ? '₹${event.tickets.first.price}' : 'Free',
                      style: const TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.w800, 
                        color: AppTheme.secondaryColor
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: CustomButton(
                  text: 'Book Now',
                  icon: Icons.confirmation_number_outlined,
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => CheckoutScreen(event: event))
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
