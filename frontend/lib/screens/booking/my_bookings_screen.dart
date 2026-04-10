import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../providers/booking_provider.dart';
import '../../core/theme.dart';
import '../../models/booking.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<BookingProvider>(context, listen: false).fetchMyBookings(),
    );
  }

  void _showQRDialog(String token, String eventTitle) {
    showDialog(
      context: context,
      builder: (context) => Transform.scale(
        scale: 1.0,
        child: AlertDialog(
          backgroundColor: AppTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: const Color(0x33FFFFFF), width: 1),
          ),
          title: Text(
            eventTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.textLight),
          ),
          content: SizedBox(
            width: 320,
            height: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: AppTheme.primaryColor.withOpacity(0.5), blurRadius: 20)
                    ]
                  ),
                  child: QrImageView(
                    data: token.isNotEmpty ? token : 'NO_TOKEN',
                    version: QrVersions.auto,
                    size: 260.0,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Scan this QR code at the entry gate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('My Tickets', style: TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold)),
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
          child: bookingProvider.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppTheme.secondaryColor))
              : bookingProvider.myBookings.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.receipt_long_rounded, size: 80, color: AppTheme.textMuted),
                          SizedBox(height: 16),
                          Text('You have no active bookings.', style: TextStyle(color: AppTheme.textMuted, fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: bookingProvider.myBookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookingProvider.myBookings[index];
                        return _buildBookingCard(booking);
                      },
                    ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final isPaid = booking.paymentStatus == 'Completed' || booking.paymentStatus == 'Paid';
    
    return GestureDetector(
      onTap: () {
        if (isPaid) _showQRDialog(booking.qrCodeToken, booking.event.title);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x33FFFFFF), width: 1),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    booking.event.bannerImage.isNotEmpty ? booking.event.bannerImage : 'https://via.placeholder.com/80',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_,__,___) => Container(width: 70, height: 70, color: const Color(0xFF1B1B2F)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.event.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textLight),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPaid ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isPaid ? Colors.green.withOpacity(0.5) : Colors.orange.withOpacity(0.5)),
                        ),
                        child: Text(
                          booking.paymentStatus,
                          style: TextStyle(
                            color: isPaid ? Colors.greenAccent : Colors.orangeAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(color: const Color(0x22FFFFFF), height: 1),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded, size: 16, color: AppTheme.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('MMM dd, yyyy').format(booking.event.date),
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  '${booking.quantity} ticket${booking.quantity > 1 ? 's' : ''}',
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  '₹${booking.totalPrice}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.secondaryColor),
                ),
              ],
            ),
            if (isPaid) ...[
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Tap to view QR Code for Entry',
                  style: TextStyle(
                    color: AppTheme.primaryColor.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
