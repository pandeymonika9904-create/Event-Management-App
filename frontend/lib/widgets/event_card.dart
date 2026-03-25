import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../core/theme.dart';
import '../screens/home/event_details_screen.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EventDetailsScreen(eventId: event.id)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0x22FFFFFF), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 10),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image & Category Badge
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: Stack(
                children: [
                  Image.network(
                    event.bannerImage.isNotEmpty 
                        ? event.bannerImage 
                        : 'https://via.placeholder.com/400x200',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: const Color(0xFF1B1B2F),
                      child: const Center(
                        child: Icon(Icons.image_not_supported_outlined, size: 50, color: AppTheme.textMuted),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0x33FFFFFF), width: 1),
                      ),
                      child: Text(
                        event.category,
                        style: const TextStyle(
                          color: AppTheme.secondaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Event Details
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textLight,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.calendar_month_rounded, size: 18, color: AppTheme.primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${DateFormat('MMM dd, yyyy').format(event.date)}  •  ${event.time}',
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.location_on_rounded, size: 18, color: AppTheme.secondaryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          event.location,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
