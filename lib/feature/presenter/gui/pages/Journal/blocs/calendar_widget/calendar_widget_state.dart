part of 'calendar_widget_bloc.dart';

abstract class CalendarWidgetState extends Equatable {
  const CalendarWidgetState();
}

class CalendarWidgetInitial extends CalendarWidgetState {
  @override
  List<Object> get props => [];
}

class CalendarWidgetLoadingState extends CalendarWidgetState {
  @override
  List<Object> get props => [];
}

class CalendarDataSucessState extends CalendarWidgetState {
  final DateTime selectedDate;
  final DateTime focusedDay;
  final Map<DateTime, List<CalendarTaskDto>> events;

  const CalendarDataSucessState({
    required this.selectedDate,
    required this.focusedDay,
    required this.events,
  });

  @override
  List<Object> get props => [selectedDate, focusedDay, events];
}

class CalendarWidgetErrorState extends CalendarWidgetState {
  final String message;

  const CalendarWidgetErrorState(this.message);
  @override
  List<Object> get props => [message];
}
