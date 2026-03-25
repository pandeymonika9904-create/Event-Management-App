class TicketCategory {
  final String id;
  final String type;
  final double price;
  final int totalAvailable;
  final int sold;

  TicketCategory({
    required this.id,
    required this.type,
    required this.price,
    required this.totalAvailable,
    required this.sold,
  });

  factory TicketCategory.fromJson(Map<String, dynamic> json) {
    return TicketCategory(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      totalAvailable: json['totalAvailable'] ?? 0,
      sold: json['sold'] ?? 0,
    );
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  final String bannerImage;
  final Map<String, dynamic> organizer;
  final String category;
  final DateTime date;
  final String time;
  final String location;
  final String status;
  final bool isTrending;
  final List<TicketCategory> tickets;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.bannerImage,
    required this.organizer,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    required this.isTrending,
    required this.tickets,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    var list = json['tickets'] as List? ?? [];
    List<TicketCategory> ticketsList = list.map((i) => TicketCategory.fromJson(i)).toList();

    return Event(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      bannerImage: json['bannerImage'] ?? '',
      organizer: json['organizer'] is Map
          ? Map<String, dynamic>.from(json['organizer'])
          : (json['organizer'] != null ? {'_id': json['organizer'].toString(), 'name': 'Unknown'} : {}),
      category: json['category'] ?? '',
      date: DateTime.parse(json['date']),
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? 'Pending',
      isTrending: json['isTrending'] ?? false,
      tickets: ticketsList,
    );
  }
}
