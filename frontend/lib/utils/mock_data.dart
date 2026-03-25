import '../models/event.dart';

class MockData {
  static List<Event> getMockEvents() {
    final now = DateTime.now();
    final events = [
      // Tech - Event 1
      {
        '_id': '1',
        'title': 'Flutter Conference 2026',
        'description':
            'Join us for an amazing day of Flutter talks, workshops, and networking.',
        'bannerImage': 'https://via.placeholder.com/400x200?text=Flutter+Conf',
        'organizer': {'name': 'Tech Events India', 'id': 'org1'},
        'category': 'Tech',
        'date': now.add(const Duration(days: 15)).toIso8601String(),
        'time': '09:00 AM - 06:00 PM',
        'location': 'Mumbai Convention Center',
        'status': 'Approved',
        'isTrending': true,
        'tickets': [
          {
            '_id': 't1',
            'type': 'Standard',
            'price': 999,
            'totalAvailable': 500,
            'sold': 260,
          },
        ],
      },
      // Tech - Event 2
      {
        '_id': '1a',
        'title': 'AI & Machine Learning Summit',
        'description':
            'Explore the latest in AI and ML technologies with industry leaders.',
        'bannerImage': 'https://via.placeholder.com/400x200?text=AI+Summit',
        'organizer': {'name': 'Tech Innovators', 'id': 'org1a'},
        'category': 'Tech',
        'date': now.add(const Duration(days: 22)).toIso8601String(),
        'time': '10:00 AM - 05:00 PM',
        'location': 'Bangalore IT Park',
        'status': 'Approved',
        'isTrending': false,
        'tickets': [
          {
            '_id': 't1a',
            'type': 'Standard',
            'price': 1299,
            'totalAvailable': 300,
            'sold': 85,
          },
        ],
      },
      // Music - Event 1
      {
        '_id': '2',
        'title': 'Jazz Night with Live Band',
        'description':
            'Experience the magic of live jazz with local and international artists.',
        'bannerImage': 'https://via.placeholder.com/400x200?text=Jazz+Night',
        'organizer': {'name': 'Music Fest Organizers', 'id': 'org2'},
        'category': 'Music',
        'date': now.add(const Duration(days: 8)).toIso8601String(),
        'time': '08:00 PM - 11:00 PM',
        'location': 'Blue Note Theater, Delhi',
        'status': 'Approved',
        'isTrending': false,
        'tickets': [
          {
            '_id': 't2',
            'type': 'General',
            'price': 1499,
            'totalAvailable': 300,
            'sold': 211,
          },
        ],
      },
      // Music - Event 2
      {
        '_id': '2a',
        'title': 'Rock Night 2026',
        'description': 'High-energy rock performances from famous bands.',
        'bannerImage': 'https://via.placeholder.com/400x200?text=Rock+Night',
        'organizer': {'name': 'Live Music Productions', 'id': 'org2a'},
        'category': 'Music',
        'date': now.add(const Duration(days: 18)).toIso8601String(),
        'time': '07:00 PM - 11:30 PM',
        'location': 'Amphitheater, Hyderabad',
        'status': 'Approved',
        'isTrending': true,
        'tickets': [
          {
            '_id': 't2a',
            'type': 'VIP',
            'price': 2499,
            'totalAvailable': 150,
            'sold': 92,
          },
        ],
      },
      // Business - Event 1
      {
        '_id': '3',
        'title': 'Startup Pitch Night',
        'description':
            'Watch promising startups pitch their ideas to investors.',
        'bannerImage': 'https://via.placeholder.com/400x200?text=Startup+Pitch',
        'organizer': {'name': 'Startup Network India', 'id': 'org3'},
        'category': 'Business',
        'date': now.add(const Duration(days: 12)).toIso8601String(),
        'time': '06:00 PM - 09:00 PM',
        'location': 'Innovation Hub, Bangalore',
        'status': 'Pending',
        'isTrending': true,
        'tickets': [
          {
            '_id': 't3',
            'type': 'Investor',
            'price': 499,
            'totalAvailable': 200,
            'sold': 60,
          },
        ],
      },
      // Business - Event 2
      {
        '_id': '3a',
        'title': 'Corporate Leadership Forum 2026',
        'description':
            'Connect with industry leaders and enhance your business network.',
        'bannerImage': 'https://via.placeholder.com/400x200?text=Leadership',
        'organizer': {'name': 'Business Insights Inc', 'id': 'org3a'},
        'category': 'Business',
        'date': now.add(const Duration(days: 25)).toIso8601String(),
        'time': '09:00 AM - 04:00 PM',
        'location': 'Corporate Tower, Mumbai',
        'status': 'Approved',
        'isTrending': false,
        'tickets': [
          {
            '_id': 't3a',
            'type': 'Premium',
            'price': 1999,
            'totalAvailable': 100,
            'sold': 45,
          },
        ],
      },
      // Food & Drink - Event 1
      {
        '_id': '4',
        'title': 'Food Festival 2026',
        'description':
            'Taste cuisines from around the world at this food fest.',
        'bannerImage': 'https://via.placeholder.com/400x200?text=Food+Festival',
        'organizer': {'name': 'Culinary Events Co', 'id': 'org4'},
        'category': 'Food & Drink',
        'date': now.add(const Duration(days: 20)).toIso8601String(),
        'time': '11:00 AM - 09:00 PM',
        'location': 'Park Grounds, Hyderabad',
        'status': 'Approved',
        'isTrending': false,
        'tickets': [
          {
            '_id': 't4',
            'type': 'Early Bird',
            'price': 299,
            'totalAvailable': 1000,
            'sold': 328,
          },
        ],
      },
      // Food & Drink - Event 2
      {
        '_id': '4a',
        'title': 'Wine Tasting Gala Evening',
        'description':
            'Premium wine tasting experience with international varieties.',
        'bannerImage': 'https://via.placeholder.com/400x200?text=Wine+Tasting',
        'organizer': {'name': 'Epicure Organizers', 'id': 'org4a'},
        'category': 'Food & Drink',
        'date': now.add(const Duration(days: 28)).toIso8601String(),
        'time': '06:00 PM - 10:00 PM',
        'location': 'Grand Hotel, Bangalore',
        'status': 'Approved',
        'isTrending': false,
        'tickets': [
          {
            '_id': 't4a',
            'type': 'Premium',
            'price': 3999,
            'totalAvailable': 80,
            'sold': 32,
          },
        ],
      },
      // Education - Event 1
      {
        '_id': '5',
        'title': 'Digital Marketing Workshop',
        'description': 'Learn digital marketing strategies for growth.',
        'bannerImage':
            'https://via.placeholder.com/400x200?text=Marketing+Workshop',
        'organizer': {'name': 'Digital Academy', 'id': 'org5'},
        'category': 'Education',
        'date': now.add(const Duration(days: 5)).toIso8601String(),
        'time': '10:00 AM - 03:00 PM',
        'location': 'Tech Hub, Pune',
        'status': 'Approved',
        'isTrending': false,
        'tickets': [
          {
            '_id': 't5',
            'type': 'Standard',
            'price': 799,
            'totalAvailable': 100,
            'sold': 58,
          },
        ],
      },
      // Education - Event 2
      {
        '_id': '5a',
        'title': 'Python Programming Masterclass',
        'description': 'Advanced Python concepts for professionals.',
        'bannerImage': 'https://via.placeholder.com/400x200?text=Python+Class',
        'organizer': {'name': 'Code Academy', 'id': 'org5a'},
        'category': 'Education',
        'date': now.add(const Duration(days: 10)).toIso8601String(),
        'time': '02:00 PM - 06:00 PM',
        'location': 'Institute of Technology, Delhi',
        'status': 'Approved',
        'isTrending': false,
        'tickets': [
          {
            '_id': 't5a',
            'type': 'Standard',
            'price': 1099,
            'totalAvailable': 50,
            'sold': 22,
          },
        ],
      },
    ];

    return events.map((e) => Event.fromJson(e)).toList();
  }

  static Map<String, dynamic> getMockOrganizerStats() {
    return {
      'totalEvents': 12,
      'activeEvents': 5,
      'totalTicketsSold': 1200,
      'totalRevenue': 450000.0,
      'pendingApproval': 2,
      'revenueLastMonth': 125000.0,
    };
  }

  static List<Map<String, dynamic>> getMockBookings() {
    return [
      {
        'id': 'BK001',
        'eventTitle': 'Flutter Conference 2026',
        'eventDate': DateTime.now().add(const Duration(days: 15)),
        'ticketsCount': 2,
        'totalPrice': 1998,
        'status': 'Confirmed',
        'qrCode': 'QR_BK001_USER123',
        'bookingDate': DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        'id': 'BK002',
        'eventTitle': 'Jazz Night with Live Band',
        'eventDate': DateTime.now().add(const Duration(days: 8)),
        'ticketsCount': 1,
        'totalPrice': 1499,
        'status': 'Confirmed',
        'qrCode': 'QR_BK002_USER123',
        'bookingDate': DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        'id': 'BK003',
        'eventTitle': 'Startup Pitch Night',
        'eventDate': DateTime.now().add(const Duration(days: 12)),
        'ticketsCount': 3,
        'totalPrice': 1497,
        'status': 'Pending',
        'qrCode': 'QR_BK003_USER123',
        'bookingDate': DateTime.now(),
      },
    ];
  }
}
