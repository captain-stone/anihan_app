import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Task model (you can extend this later if needed)
class CalendarTask {
  final String name;
  final String status;

  CalendarTask({required this.name, this.status = 'upcoming'});
}

// Calendar State
class CalendarState extends Equatable {
  final DateTime selectedDate;
  final DateTime focusedDay;
  final Map<DateTime, List<CalendarTask>> events;

  const CalendarState({
    required this.selectedDate,
    required this.focusedDay,
    required this.events,
  });

  @override
  List<Object> get props => [selectedDate, focusedDay, events];
}

// Calendar Event Base Class
abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

// Events
class SelectDateEvent extends CalendarEvent {
  final DateTime selectedDate;
  final DateTime focusedDay;

  const SelectDateEvent(this.selectedDate, this.focusedDay);

  @override
  List<Object> get props => [selectedDate, focusedDay];
}

class AddTaskEvent extends CalendarEvent {
  final DateTime date;
  final String taskName;

  const AddTaskEvent(this.date, this.taskName);

  @override
  List<Object> get props => [date, taskName];
}

class LoadInitialEvents extends CalendarEvent {}

// Calendar Bloc
class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc()
      : super(CalendarState(
          selectedDate: DateTime.now(),
          focusedDay: DateTime.now(),
          events: _initializeDummyEvents(),
        )) {
    on<SelectDateEvent>(_onSelectDate);
    on<AddTaskEvent>(_onAddTask);
    on<LoadInitialEvents>(_onLoadInitialEvents);
  }

  // Handler for selecting a date
  void _onSelectDate(SelectDateEvent event, Emitter<CalendarState> emit) {
    emit(CalendarState(
      selectedDate: event.selectedDate,
      focusedDay: event.focusedDay,
      events: state.events,
    ));
  }

  // Handler for adding a task
  void _onAddTask(AddTaskEvent event, Emitter<CalendarState> emit) {
    final updatedEvents = Map<DateTime, List<CalendarTask>>.from(state.events);
    final normalizedDate =
        DateTime(event.date.year, event.date.month, event.date.day);

    if (!updatedEvents.containsKey(normalizedDate)) {
      updatedEvents[normalizedDate] = [];
    }

    // Add the new task
    updatedEvents[normalizedDate]!.add(CalendarTask(name: event.taskName));

    emit(CalendarState(
      selectedDate: state.selectedDate,
      focusedDay: state.focusedDay,
      events: updatedEvents,
    ));
  }

  // Load initial dummy events (sample data)
  void _onLoadInitialEvents(
      LoadInitialEvents event, Emitter<CalendarState> emit) {
    emit(CalendarState(
      selectedDate: state.selectedDate,
      focusedDay: state.focusedDay,
      events: _initializeDummyEvents(),
    ));
  }

  // Initialize dummy events for demonstration
  static Map<DateTime, List<CalendarTask>> _initializeDummyEvents() {
    final Map<DateTime, List<CalendarTask>> events = {};
    final DateTime today = DateTime.now();

    DateTime normalizeDate(DateTime date) {
      return DateTime(date.year, date.month, date.day);
    }

    // Past events
    events[normalizeDate(today.subtract(const Duration(days: 2)))] = [
      CalendarTask(name: 'Weeding', status: 'missed'),
      CalendarTask(name: 'Harvesting', status: 'done'),
    ];

    events[normalizeDate(today.subtract(const Duration(days: 5)))] = [
      CalendarTask(name: 'Fertilizer Application', status: 'missed'),
    ];

    // Current date events
    events[normalizeDate(today)] = [
      CalendarTask(name: 'Watering Schedule'),
      CalendarTask(name: 'Inspection'),
    ];

    // Future events
    events[normalizeDate(today.add(const Duration(days: 2)))] = [
      CalendarTask(name: 'Soil Preparation'),
    ];

    events[normalizeDate(today.add(const Duration(days: 5)))] = [
      CalendarTask(name: 'Planting Day'),
    ];

    return events;
  }
}
