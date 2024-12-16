import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/api/calendar_task_api.dart';
import 'package:anihan_app/feature/data/models/dto/calendar_task_dto.dart';
import 'package:anihan_app/feature/domain/parameters/calendar_task_params.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'calendar_widget_event.dart';
part 'calendar_widget_state.dart';

@injectable
class CalendarWidgetBloc
    extends Bloc<CalendarWidgetEvent, CalendarWidgetState> {
  final Logger logger = Logger();
  CalendarWidgetBloc() : super(CalendarWidgetInitial()) {
    on<CalendarSelectDateEvent>(
      (event, emit) async {
        emit(CalendarWidgetLoadingState());
        final CalendarTaskApi _calendarApi = CalendarTaskApi();

        try {
          var result = await _calendarApi.getAllCalendarTask();
          Status status = result.status;
          ErrorType? errorType = result.errorType;

          if (status != Status.error) {
            var data = result.data;
            if (data != null && data.isNotEmpty) {
              // for (var dataCalendar in data) {}
              emit(CalendarDataSucessState(
                  selectedDate: event.selectedDate,
                  focusedDay: event.focusedDay,
                  events: data));
            }

            // emit(CalendarWidgetLoadingState());
          } else {
            if (errorType == ErrorType.nullError) {
              emit(CalendarDataSucessState(
                  selectedDate: event.selectedDate,
                  focusedDay: event.focusedDay,
                  events: {}));
            } else {
              emit(CalendarWidgetErrorState(result.message!));
            }
          }
        } catch (e) {
          logger.e(e);
          emit(CalendarWidgetErrorState("There's an error: (error) $e"));
        }

        // emit(CalendarDataSucessState(
        //     selectedDate: event.selectedDate,
        //     focusedDay: event.focusedDay,
        //     events: {}));
      },
    );

    on<CalendarAddTaskEvent>((event, emit) async {
      final CalendarTaskApi _calendarApi = CalendarTaskApi();
      var params = event.params;
      var taskStatus = params.status;

      try {
        var result = await _calendarApi.addCalendarTask(
            dateTask: params.selectedDateString,
            task: CalendarTaskDto(
                name: params.taskName, status: taskStatus ?? "ongoing"));

        Status status = result.status;

        if (status != Status.error) {
          var data = result.data;
          if (data != null && data.isNotEmpty) {
            // for (var dataCalendar in data) {}
            emit(CalendarDataSucessState(
                selectedDate: DateTime.parse(params.dateTimeString),
                focusedDay: DateTime.parse(params.focusDateString),
                events: data));
          } else {
            emit(CalendarWidgetErrorState(result.message!));
          }

          // emit(CalendarWidgetLoadingState());
        } else {
          emit(CalendarWidgetErrorState(result.message!));
        }
      } catch (e) {
        logger.e(e);
        emit(CalendarWidgetErrorState("There's an error: (error) $e"));
      }
    });

    on<CalendarUpdateTaskEvent>((event, emit) {
      // final currentState = state as CalendarDataSucessState;
      // final updatedEvents =
      //     Map<DateTime, List<CalendarTaskDto>>.from(currentState.events);
      // final normalizedDate =
      //     DateTime(event.date.year, event.date.month, event.date.day);
      // if (!updatedEvents.containsKey(normalizedDate)) {
      //   updatedEvents[normalizedDate] = [];
      // }
      // // If you have a separate CalendarTask class, convert it to CalendarTaskDto
      // final calendarTaskDto =
      //     CalendarTaskDto(name: event.taskName, status: 'done');
      // updatedEvents[normalizedDate]!.add(calendarTaskDto);
      // emit(CalendarDataSucessState(
      //   selectedDate: currentState.selectedDate,
      //   focusedDay: currentState.focusedDay,
      //   events: updatedEvents,
      // ));
    });
  }

  static CalendarTaskDateDto _initializeDummyEvents() {
    final DateTime today = DateTime.now();

    DateTime normalizeDate(DateTime date) {
      return DateTime(date.year, date.month, date.day);
    }

    final CalendarTaskDateDto events = CalendarTaskDateDto(
        dateTime: normalizeDate(today).toIso8601String(), data: []);

    // Past events
    // events. = [];

    // events[normalizeDate(today.subtract(const Duration(days: 5)))] = [
    //   CalendarTaskDto(name: 'Fertilizer Application', status: 'missed'),
    // ];

    // // Current date events
    // events[normalizeDate(today)] = [
    //   CalendarTaskDto(name: 'Watering Schedule', status: ''),
    //   CalendarTaskDto(name: 'Inspection', status: ''),
    // ];

    // // Future events
    //  [normalizeDate(today.add(const Duration(days: 2)))] = [
    //   CalendarTaskDto(name: 'Soil Preparation', status: ''),
    // ];

    // events[normalizeDate(today.add(const Duration(days: 5)))] = [
    //   CalendarTaskDto(name: 'Planting Day', status: ''),
    // ];

    return events;
  }
}
