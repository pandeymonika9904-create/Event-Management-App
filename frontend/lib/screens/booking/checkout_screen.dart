import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../models/event.dart';
import '../../models/booking.dart';
import '../../providers/booking_provider.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final Event event;

  const CheckoutScreen({super.key, required this.event});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedTicketType;
  int _quantity = 1;
  late Razorpay _razorpay;
  String? _currentBookingId;

  @override
  void initState() {
    super.initState();
    if (widget.event.tickets.isNotEmpty) {
      _selectedTicketType = widget.event.tickets.first.type;
    }
    
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (_currentBookingId == null) return;
    
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final isVerified = await bookingProvider.verifyPayment(
      response.orderId ?? '', 
      response.paymentId ?? '', 
      response.signature ?? '', 
      _currentBookingId!
    );

    if (isVerified && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PaymentSuccessScreen(bookingId: _currentBookingId!)),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bookingProvider.error.isEmpty ? 'Verification Failed' : bookingProvider.error)),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet Selected: ${response.walletName}')),
    );
  }

  double get _totalPrice {
    if (_selectedTicketType == null) return 0;
    final ticket = widget.event.tickets.firstWhere((t) => t.type == _selectedTicketType);
    return ticket.price * _quantity;
  }

  void _processPayment() async {
    if (_selectedTicketType == null) return;

    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    
    // 1. Create Booking in DB
    final responseData = await bookingProvider.createBooking(
      widget.event.id, 
      _selectedTicketType!, 
      _quantity
    );

    if (responseData != null) {
      final Booking booking = responseData['booking'];
      final String orderId = responseData['orderId'];
      final int amount = responseData['amount'];
      _currentBookingId = booking.id;

      // 2. Open Razorpay Interface
      var options = {
        'key': 'rzp_test_dummy_key_here', // In production, fetch via API or use env
        'amount': amount,
        'name': 'Event Management System',
        'order_id': orderId,
        'description': 'Booking for ${widget.event.title}',
        'prefill': {
          'contact': '9876543210',
          'email': 'test@razorpay.com'
        }
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint(e.toString());
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bookingProvider.error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.event.tickets.isEmpty) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Checkout', style: TextStyle(color: Colors.white)),
        ),
        body: Container(
          decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
          child: const Center(child: Text('No tickets available for this event', style: TextStyle(color: AppTheme.textMuted))),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold)),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Summary (Glassmorphism card)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0x33FFFFFF), width: 1),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          widget.event.bannerImage,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_,__,___) => Container(width: 80, height: 80, color: const Color(0xFF1B1B2F)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.event.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.textLight),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.event.location,
                              style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                const Text('Select Ticket Tier', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppTheme.textLight)),
                const SizedBox(height: 16),
                
                ...widget.event.tickets.map((ticket) {
                  final isSelected = _selectedTicketType == ticket.type;
                  final available = ticket.totalAvailable - ticket.sold;
                  return GestureDetector(
                    onTap: () {
                      if (available > 0) {
                        setState(() => _selectedTicketType = ticket.type);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor.withOpacity(0.15) : AppTheme.cardColor,
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryColor : const Color(0x22FFFFFF),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected ? [
                          BoxShadow(color: AppTheme.primaryColor.withOpacity(0.2), blurRadius: 15)
                        ] : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ticket.type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.textLight)),
                              const SizedBox(height: 4),
                              Text(
                                available > 0 ? '$available left' : 'Sold Out', 
                                style: TextStyle(
                                  color: available > 0 ? AppTheme.textMuted : AppTheme.accentColor, 
                                  fontSize: 13,
                                  fontWeight: available == 0 ? FontWeight.bold : FontWeight.normal
                                )
                              ),
                            ],
                          ),
                          Text('₹${ticket.price}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: AppTheme.secondaryColor)),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 32),
                const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppTheme.textLight)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0x44FFFFFF)),
                        ),
                        child: const Icon(Icons.remove_rounded, color: AppTheme.textLight),
                      ),
                    ),
                    Container(
                      width: 80,
                      alignment: Alignment.center,
                      child: Text('$_quantity', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textLight)),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _quantity++),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0x44FFFFFF)),
                        ),
                        child: const Icon(Icons.add_rounded, color: AppTheme.textLight),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
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
                    const Text('Total Amount', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                      '₹$_totalPrice',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.secondaryColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: CustomButton(
                  text: 'Pay & Book',
                  icon: Icons.lock_outline_rounded,
                  onPressed: _processPayment,
                  isLoading: Provider.of<BookingProvider>(context).isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
