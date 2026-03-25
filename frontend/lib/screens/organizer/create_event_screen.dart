import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _ticketsController = TextEditingController();
  final _bannerImageController = TextEditingController();

  DateTime? _eventDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: AppTheme.cardColor,
              onSurface: AppTheme.textLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _eventDate = date);
    }
  }

  Future<void> _pickStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: AppTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() => _startTime = time);
    }
  }

  Future<void> _pickEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: AppTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() => _endTime = time);
    }
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _bannerImageController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _ticketsController.text.isEmpty ||
        _eventDate == null ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields before submitting.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    if (_endTime != null && _startTime != null) {
      final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
      final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
      if (endMinutes <= startMinutes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'End time should be after start time.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }
    }

    final eventData = {
      'title': _titleController.text,
      'description': _descController.text,
      'bannerImage': _bannerImageController.text,
      'location': _locationController.text,
      'date': _eventDate!.toIso8601String(),
      'time':
          '${_startTime!.hour}:${_startTime!.minute.toString().padLeft(2, '0')}',
      'category': 'Other', // Basic fallback
      'tickets': [
        {
          'type': 'General',
          'price': double.parse(_priceController.text),
          'totalAvailable': int.parse(_ticketsController.text),
        },
      ],
    };

    final success = await context.read<EventProvider>().createEvent(eventData);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Event Created Successfully! Pending Admin Approval.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.read<EventProvider>().error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Create Event',
          style: TextStyle(
            color: AppTheme.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.5),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
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
                GestureDetector(
                  onTap: () {}, // Image picker logic
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.5),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 40,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Upload Event Banner',
                          style: TextStyle(
                            color: AppTheme.textLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '1920 x 1080 recommended',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _titleController,
                  hintText: 'Event Title',
                  prefixIcon: Icons.title_rounded,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descController,
                  hintText: 'Event Description',
                  prefixIcon: Icons.description_rounded,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _bannerImageController,
                  hintText: 'Banner Image URL',
                  prefixIcon: Icons.image_rounded,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _locationController,
                  hintText: 'Location / Venue',
                  prefixIcon: Icons.location_on_rounded,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: TextEditingController(
                        text: _eventDate == null
                            ? ''
                            : '${_eventDate!.day}/${_eventDate!.month}/${_eventDate!.year}',
                      ),
                      hintText: 'Event Date',
                      prefixIcon: Icons.calendar_today_rounded,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickStartTime,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: TextEditingController(
                              text: _startTime == null
                                  ? ''
                                  : _startTime!.format(context),
                            ),
                            hintText: 'Start Time',
                            prefixIcon: Icons.watch_later_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickEndTime,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: TextEditingController(
                              text: _endTime == null
                                  ? ''
                                  : _endTime!.format(context),
                            ),
                            hintText: 'End Time',
                            prefixIcon: Icons.watch_later_rounded,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _priceController,
                        hintText: 'Ticket Price',
                        prefixIcon: Icons.currency_rupee_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        controller: _ticketsController,
                        hintText: 'Total Tickets',
                        prefixIcon: Icons.confirmation_num_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'Submit Event',
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: _submit,
                  isLoading: context.watch<EventProvider>().isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
