import 'package:anihan_app/feature/domain/parameters/params.dart';

class CalendarTaskParams extends Params {
  final String dateTimeString;
  final int selectedDateString;
  final String focusDateString;
  final String taskName;
  final String? status;

  CalendarTaskParams(
      {required this.dateTimeString,
      required this.focusDateString,
      required this.selectedDateString,
      required this.taskName,
      this.status});
  @override
  List<Object?> get props =>
      [dateTimeString, focusDateString, selectedDateString, taskName, status];
}
