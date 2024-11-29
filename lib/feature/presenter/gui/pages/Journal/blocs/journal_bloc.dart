import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class JournalEntry {
  final String date;
  final String title;
  final String description;
  final List<dynamic> photos; // Supports File (Mobile) or Uint8List (Web)

  JournalEntry({
    required this.date,
    required this.title,
    required this.description,
    this.photos = const [],
  });

  @override
  String toString() {
    return 'JournalEntry(date: $date, title: $title, description: $description, photos: ${photos.length} attachments)';
  }
}

// States
abstract class JournalState extends Equatable {
  const JournalState();

  @override
  List<Object?> get props => [];
}

class JournalInitial extends JournalState {}

class JournalLoaded extends JournalState {
  final List<JournalEntry> entries;

  const JournalLoaded(this.entries);

  @override
  List<Object?> get props => [entries];
}

// Events
abstract class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object?> get props => [];
}

class LoadJournalEntries extends JournalEvent {}

class AddJournalEntry extends JournalEvent {
  final JournalEntry entry;

  const AddJournalEntry(this.entry);

  @override
  List<Object?> get props => [entry];
}

class DeleteJournalEntry extends JournalEvent {
  final JournalEntry entry;

  const DeleteJournalEntry(this.entry);

  @override
  List<Object?> get props => [entry];
}

// Bloc
class JournalBloc extends Bloc<JournalEvent, JournalState> {
  JournalBloc() : super(JournalInitial()) {
    on<LoadJournalEntries>((event, emit) {
      // Sample entries for initial load
      final sampleEntries = [
        JournalEntry(
          date: '2024-11-01',
          title: 'Planting Day',
          description:
              'Started planting new crops today. Sunny weather was perfect for planting.',
          photos: [],
        ),
        JournalEntry(
          date: '2024-11-02',
          title: 'Watering Schedule',
          description:
              'Watered the plants in the morning. Soil moisture level was optimal.',
          photos: [],
        ),
        JournalEntry(
          date: '2024-11-03',
          title: 'Fertilizer Applied',
          description: 'Applied organic fertilizer. Rain is expected tomorrow.',
          photos: [],
        ),
        JournalEntry(
          date: '2024-11-04',
          title: 'Rainy Day',
          description: 'Heavy rain today. Checked for signs of waterlogging.',
          photos: [],
        ),
        JournalEntry(
          date: '2024-11-05',
          title: 'Pest Control',
          description:
              'Noticed pests on crops. Applied natural pesticide as a precaution.',
          photos: [],
        ),
      ];

      emit(JournalLoaded(sampleEntries));
    });

    on<AddJournalEntry>((event, emit) {
      if (state is JournalLoaded) {
        final currentState = state as JournalLoaded;
        final updatedEntries = List<JournalEntry>.from(currentState.entries)
          ..add(event.entry);
        emit(JournalLoaded(updatedEntries));
      }
    });

    on<DeleteJournalEntry>((event, emit) {
      if (state is JournalLoaded) {
        final currentState = state as JournalLoaded;
        final updatedEntries = currentState.entries
            .where((entry) => entry != event.entry)
            .toList();
        emit(JournalLoaded(updatedEntries));
      }
    });
  }
}
