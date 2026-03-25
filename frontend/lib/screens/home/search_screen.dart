import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../core/theme.dart';
import '../../widgets/event_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _search(String query) {
    final provider = Provider.of<EventProvider>(context, listen: false);
    provider.fetchEvents(keyword: query);
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: _search,
          cursorColor: AppTheme.primaryColor,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search events...',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (value) => setState(() {}),
        ),
      ),
      body: eventProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventProvider.events.isEmpty
          ? const Center(child: Text('No matching events found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: eventProvider.events.length,
              itemBuilder: (context, index) {
                return EventCard(event: eventProvider.events[index]);
              },
            ),
    );
  }
}
