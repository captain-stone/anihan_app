// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously, unnecessary_cast, unnecessary_nullable_for_final_variable_declarations

import 'package:anihan_app/feature/data/models/dto/journal_entry_dto.dart';
import 'package:anihan_app/feature/domain/parameters/journal_entry_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
// import 'package:logger/logger.dart';
import '../../../../../../common/app_module.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '../blocs/journal_widget/journal_widget_bloc.dart';

class JournalEntriesWidget extends StatefulWidget {
  const JournalEntriesWidget({super.key});

  @override
  _JournalEntriesWidgetState createState() => _JournalEntriesWidgetState();
}

class _JournalEntriesWidgetState extends State<JournalEntriesWidget> {
  DateTimeRange? _selectedDateRange;
  final _journalBloc = getIt<JournalWidgetBloc>();
  // final Logger logger = Logger();

  @override
  void initState() {
    super.initState();

    _journalBloc.add(const JournalOnLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalWidgetBloc, JournalWidgetState>(
      bloc: _journalBloc,
      builder: (context, state) {
        // logger.d(state);
        // List<JournalEntryParams> filteredEntries = [];
        List<JournalEntryDto> filteredDtoEntries = [];

        if (state is JournalWidgetLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is JournalWidgetSuccessState) {
          if (_selectedDateRange == null) {
            filteredDtoEntries = state.entry;
          } else {
            filteredDtoEntries = state.entry.where((entry) {
              final entryDate = DateTime.parse(entry.date);
              return entryDate.isAfter(_selectedDateRange!.start
                      .subtract(const Duration(days: 1))) &&
                  entryDate.isBefore(
                      _selectedDateRange!.end.add(const Duration(days: 1)));
            }).toList();
          }
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Date Range Filter Button and "New Entry" Button
              const Divider(
                color: Colors.green,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.book_outlined,
                      color: Colors.black87, size: 24),
                  Text(
                    'Journal Entries',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.black87),
                    tooltip: 'Filter Entries',
                    onPressed: () => _selectDateRange(context),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'New Entry',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddJournalEntryDialog(
                          journalBloc: _journalBloc,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Display Date Range Filter Information
              if (_selectedDateRange != null)
                Text(
                  'Showing entries from ${DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start.toLocal())} to ${DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end.toLocal())}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              const SizedBox(height: 12),
              // Entries List or Empty State
              if (filteredDtoEntries.isNotEmpty)
                _buildEntriesList(context, filteredDtoEntries)
              else
                _buildEmptyState(context),
            ],
          ),
        );
      },
    );
  }

  void _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.green.shade700,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black87,
                  background: Colors.green.shade100,
                ),
            dialogBackgroundColor: Colors.green.shade50,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green.shade700,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });

      // Display a confirmation message with a custom SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Filtered entries from ${picked.start.toLocal().toString().split(' ')[0]} '
            'to ${picked.end.toLocal().toString().split(' ')[0]}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );
    }
  }

  Widget _buildEntriesList(
      BuildContext context, List<JournalEntryDto> entries) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        // logger.d("${entry.title}\n${entry.photos}");
        return ExpandableJournalEntry(entry: entry);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.note_add,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(height: 18),
          Text(
            'No entries found for the selected date range!',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: 8),
          // Text(
          //   'Try adjusting the date range or add a new entry.',
          //   style: Theme.of(context).textTheme.bodyMedium,
          // ),
        ],
      ),
    );
  }
}

class AddJournalEntryDialog extends StatefulWidget {
  final JournalWidgetBloc journalBloc;
  const AddJournalEntryDialog({super.key, required this.journalBloc});

  @override
  _AddJournalEntryDialogState createState() => _AddJournalEntryDialogState();
}

class _AddJournalEntryDialogState extends State<AddJournalEntryDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  List<Uint8List> _selectedPhotos =
      []; // Supports File (Mobile) or Uint8List (Web)
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dialog Title
              Text(
                'Add New Journal Entry',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              // Title Input Field
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 12),
              // Description Input Field
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              // Date Picker Field
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.green),
                    onPressed: () => _pickDate(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Photo Attachment Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add Photos',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.photo, color: Colors.green),
                    onPressed: () => _pickImages(),
                  ),
                ],
              ),
              // Photo Preview
              if (_selectedPhotos.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedPhotos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.memory(
                              _selectedPhotos[index] as Uint8List,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              // Save and Cancel Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final title = _titleController.text;
                      final description = _descriptionController.text;

                      if (title.isNotEmpty &&
                          description.isNotEmpty &&
                          _selectedDate != null) {
                        final newEntry = JournalEntryParams(
                          date:
                              _selectedDate!.toIso8601String().split('T').first,
                          title: title,
                          description: description,
                          photos: _selectedPhotos,
                        );

                        // Dispatch AddJournalEntry event
                        widget.journalBloc.add(AddJournalEvent(newEntry));
                        Navigator.of(context).pop();
                      } else {
                        // Show a validation error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields.'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Date Picker Function
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Image Picker Function
  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      // Convert the picked files to Uint8List
      final List<Uint8List> photoBytes = [];
      for (XFile file in pickedFiles) {
        final Uint8List bytes = await File(file.path).readAsBytes();
        photoBytes.add(bytes);
      }

      setState(() {
        _selectedPhotos =
            photoBytes; // Assuming _selectedPhotos is List<Uint8List>
      });
    }
  }
}

class ExpandableJournalEntry extends StatefulWidget {
  final JournalEntryDto entry;

  const ExpandableJournalEntry({super.key, required this.entry});

  @override
  _ExpandableJournalEntryState createState() => _ExpandableJournalEntryState();
}

class _ExpandableJournalEntryState extends State<ExpandableJournalEntry> {
  bool _isExpanded = false;
  // final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Date Tag and Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.entry.title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  widget.entry.date,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ],
          ),
          if (_isExpanded)
            Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  widget.entry.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                // Display sample images if the entry is expanded
                SizedBox(
                  height: 150,
                  width: 500,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.entry.photos.length,
                    itemBuilder: (context, index) {
                      // logger.d(widget.entry.photos[index]);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            widget.entry
                                .photos[index], // Using the URL from the list
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
