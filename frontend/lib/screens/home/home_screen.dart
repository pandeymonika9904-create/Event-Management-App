import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../../core/theme.dart';
import '../../widgets/event_card.dart';
import '../auth/login_screen.dart';
import '../profile/profile_screen.dart';
import '../booking/my_bookings_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Music',
    'Tech',
    'Food',
    'Business',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<EventProvider>(context, listen: false).fetchEvents(),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Discover Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: RefreshIndicator(
            color: AppTheme.secondaryColor,
            backgroundColor: AppTheme.cardColor,
            onRefresh: () async {
              await eventProvider.fetchEvents(
                category: _selectedCategory == 'All' ? '' : _selectedCategory,
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find your next vibe',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Categories
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final isSelected =
                            _selectedCategory == categories[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = categories[index];
                            });
                            eventProvider.fetchEvents(
                              category: _selectedCategory == 'All'
                                  ? ''
                                  : _selectedCategory,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 0,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? AppTheme.primaryGradient
                                  : null,
                              color: isSelected ? null : AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : const Color(0x33FFFFFF),
                                width: 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.primaryColor
                                            .withOpacity(0.4),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textMuted,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  if (eventProvider.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(60.0),
                        child: CircularProgressIndicator(
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    )
                  else if (eventProvider.error.isNotEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Text(
                          eventProvider.error,
                          style: const TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else if (eventProvider.events.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(60.0),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.event_busy_rounded,
                              size: 60,
                              color: AppTheme.textMuted,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No events found',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...eventProvider.events
                        .map((event) => EventCard(event: event))
                        ,
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
