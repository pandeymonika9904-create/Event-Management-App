import 'event.dart';

class Booking {
  final String id;
  final Event event;
  final String ticketType;
  final int quantity;
  final double totalPrice;
  final String paymentStatus;
  final String qrCodeToken;
  final bool checkInStatus;

  Booking({
    required this.id,
    required this.event,
    required this.ticketType,
    required this.quantity,
    required this.totalPrice,
    required this.paymentStatus,
    required this.qrCodeToken,
    required this.checkInStatus,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? '',
      event: Event.fromJson(json['event'] ?? {}),
      ticketType: json['ticketType'] ?? '',
      quantity: json['quantity'] ?? 1,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'Pending',
      qrCodeToken: json['qrCodeToken'] ?? '',
      checkInStatus: json['checkInStatus'] ?? false,
    );
  }
}
