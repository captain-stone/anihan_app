part of 'calendar_widget_bloc.dart';

abstract class CalendarWidgetEvent extends Equatable {
  const CalendarWidgetEvent();

  @override
  List<Object> get props => [];
}

class CalendarSelectDateEvent extends CalendarWidgetEvent {
  final DateTime selectedDate;
  final DateTime focusedDay;

  const CalendarSelectDateEvent(this.selectedDate, this.focusedDay);

  @override
  List<Object> get props => [selectedDate, focusedDay];
}

class CalendarAddTaskEvent extends CalendarWidgetEvent {
  final CalendarTaskParams params;

  const CalendarAddTaskEvent(this.params);

  @override
  List<Object> get props => [params];
}

class CalendarUpdateTaskEvent extends CalendarWidgetEvent {
  final CalendarTaskParams params;

  const CalendarUpdateTaskEvent(this.params);

  @override
  List<Object> get props => [params];
}
