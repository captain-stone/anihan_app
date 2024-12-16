import 'package:anihan_app/feature/data/models/dto/calendar_task_dto.dart';
import 'package:anihan_app/feature/domain/parameters/calendar_task_params.dart';
import 'package:anihan_app/feature/presenter/gui/pages/Journal/blocs/calendar_widget/calendar_widget_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../../common/app_module.dart';
import '../blocs/calendar_bloc.dart';

class CalendarWidget extends StatefulWidget {
  CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final logger = Logger();
  final _calendarBloc = getIt<CalendarWidgetBloc>();
  final TextEditingController taskNameController = TextEditingController();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<CalendarTaskDto>> datatask = {};
  bool isCheckValue = false;

  @override
  void initState() {
    super.initState();

    _calendarBloc.add(CalendarSelectDateEvent(DateTime.now(), DateTime.now()));
  }

  Widget _calendarInit(CalendarDataSucessState state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: state.focusedDay,
        selectedDayPredicate: (day) => isSameDay(day, state.selectedDate),
        rowHeight: 60.0,
        eventLoader: (day) {
          DateTime normalizedDay = DateTime(day.year, day.month, day.day);
          logger.e(normalizedDay);
          // return DateTime.parse(state.events.dateTime) == normalizedDay
          //     ? state.events.data
          //     : [];

          return state.events[normalizedDay] ?? [];
        },
        onDaySelected: (selectedDay, focusedDay) {
          // Dispatch the SelectDateEvent to update the selected and focused dates
          // logger.d("sadsadsada");
          // setState(() {
          //   _selectedDay = selectedDay;
          // });

          // _calendarBloc
          //     .add(CalendarSelectDateEvent(selectedDay, focusedDay));
          // _showAddTaskDialog(context, selectedDay);
          _showEventDialog(context, selectedDay, focusedDay, state.events);
        },
        onPageChanged: (focusedDay) {
          // Dispatch the SelectDateEvent when the page (month) changes
          _calendarBloc.add(CalendarSelectDateEvent(focusedDay, focusedDay));
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: BoxShape.circle, // Use rectangle if you need rounded corners

            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
          ),
          markerDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          markersMaxCount: 6,
          markersAlignment: Alignment.bottomCenter,
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          leftChevronIcon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          rightChevronIcon: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              return Positioned(
                bottom: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: events.take(4).map((event) {
                    // logger.d(event);
                    if (event is Map<String, String>) {
                      String status = event['status'] ?? 'upcoming';
                      Color indicatorColor;

                      switch (status) {
                        case 'missed':
                          indicatorColor = Colors.red;
                          break;
                        case 'done':
                          indicatorColor = Colors.green;
                          break;
                        case 'upcoming':
                        default:
                          indicatorColor = Colors.grey;
                          break;
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        width: 6.0,
                        height: 6.0,
                        decoration: BoxDecoration(
                          color: indicatorColor,
                          shape: BoxShape.circle,
                        ),
                      );
                    } else {
                      // Return a default gray indicator if event type is not a map
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        width: 6.0,
                        height: 6.0,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      );
                    }
                  }).toList(),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarWidgetBloc, CalendarWidgetState>(
      bloc: _calendarBloc,
      listener: (context, state) {
        // if (state is CalendarDataSucessState) {
        //   setState(() {
        //     datatask = state.events.data;
        //   });
        // }
      },
      builder: (context, state) {
        // logger.d(state);
        // state = state is CalendarWidgetInitial ? CalendarWidgetState : CalendarWidgetState;
        // if (state is CalendarWidgetInitial) {
        //   return _calendarInit(state);
        // }
        if (state is CalendarDataSucessState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: state.focusedDay,
              selectedDayPredicate: (day) => isSameDay(day, state.selectedDate),
              rowHeight: 60.0,
              eventLoader: (day) {
                DateTime normalizedDay = DateTime(day.year, day.month, day.day);
                // logger.d(normalizedDay);
                return state.events[normalizedDay] ?? [];

                // return state.events.data;
              },
              onDaySelected: (selectedDay, focusedDay) {
                // Dispatch the SelectDateEvent to update the selected and focused dates
                // logger.d("sadsadsada");
                setState(() {
                  _selectedDay = selectedDay;
                });

                // _calendarBloc
                //     .add(CalendarSelectDateEvent(selectedDay, focusedDay));
                // _showAddTaskDialog(context, selectedDay);
                _showEventDialog(
                    context, selectedDay, focusedDay, state.events);
              },
              onPageChanged: (focusedDay) {
                // Dispatch the SelectDateEvent when the page (month) changes
                _calendarBloc
                    .add(CalendarSelectDateEvent(focusedDay, focusedDay));
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape
                      .circle, // Use rectangle if you need rounded corners

                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                markerDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                markersMaxCount: 6,
                markersAlignment: Alignment.bottomCenter,
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                leftChevronIcon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                rightChevronIcon: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: events.take(4).map((event) {
                          // logger.d(event);
                          if (event is Map<String, String>) {
                            String status = event['status'] ?? 'upcoming';
                            Color indicatorColor;

                            switch (status) {
                              case 'missed':
                                indicatorColor = Colors.red;
                                break;
                              case 'done':
                                indicatorColor = Colors.green;
                                break;
                              case 'upcoming':
                              default:
                                indicatorColor = Colors.grey;
                                break;
                            }

                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              width: 6.0,
                              height: 6.0,
                              decoration: BoxDecoration(
                                color: indicatorColor,
                                shape: BoxShape.circle,
                              ),
                            );
                          } else {
                            // Return a default gray indicator if event type is not a map
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              width: 6.0,
                              height: 6.0,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            );
                          }
                        }).toList(),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future<String?> _showAddTaskDialog(
      BuildContext context, DateTime date) async {
    String? task = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
            colorMessage: Colors.green,
            title: "Add new Task",
            actionOkayVisibility: true,
            actionLabel: "Add",
            onPressOkay: () {
              final String taskName = taskNameController.text.trim();
              if (taskName.isNotEmpty) {
                Navigator.of(context).pop(taskName);
              }
            },
            onPressedCloseBtn: () {
              Navigator.of(context).pop();
            },
            child: TextField(
              controller: taskNameController,
              decoration: const InputDecoration(
                labelText: 'Task Name',
                hintText: 'Enter task name',
                prefixIcon: Icon(Icons.task),
              ),
            ));
      },
    );
    return task;
  }

  bool _isDialogOpen = false;

  // Function to show the event dialog
  void _showEventDialog(BuildContext context, DateTime date, DateTime focusData,
      Map<DateTime, List<CalendarTaskDto>> events) {
    final DateTime normalizedDate = DateTime(date.year, date.month, date.day);

    var eventList = events[normalizedDate] ?? [];
    final DateTime today = DateTime.now();
    final DateTime todayWithoutTime =
        DateTime(today.year, today.month, today.day);
    bool isPastDate =
        normalizedDate.isBefore(DateTime(today.year, today.month, today.day));
    logger.d(normalizedDate);
    Map<String, bool> checkboxStates = {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) =>
                BlocBuilder<CalendarWidgetBloc, CalendarWidgetState>(
                  bloc: _calendarBloc,
                  builder: (context, state) {
                    logger.d(state);
                    // Handle loading and error states
                    if (state is CalendarWidgetLoadingState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is CalendarWidgetErrorState) {
                      return Center(child: Text('Failed to load events'));
                    }

                    if (state is CalendarDataSucessState) {
                      // setState(() {
                      datatask = state.events;
                      eventList = state.events[normalizedDate] ?? [];
                      // });
                    }

                    // if (state is CalendarWidgetInitial) {
                    //   logger.d(state.events[normalizedDate]);
                    // }

                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      backgroundColor: Colors.green.shade50,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Dialog Title
                            Text(
                              'Tasks for ${normalizedDate.toLocal().toString().split(' ')[0]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16.0),
                            // List of Tasks
                            if (eventList.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: eventList.length,
                                itemBuilder: (context, index) {
                                  final event = eventList[index];
                                  final String taskName = event.name;
                                  String status = event.status;
                                  IconData statusIcon;
                                  Color statusColor;
                                  bool isTaskEditable = false;
                                  // logger.d("$normalizedDate\n$today");
                                  // logger.d(status);

                                  // Determine task status and icon
                                  if (status == 'done') {
                                    statusIcon = Icons.check_circle;
                                    statusColor = Colors.green;
                                    isTaskEditable = false;
                                  } else if (status == 'missed') {
                                    statusIcon = Icons.error;
                                    statusColor = Colors.red;
                                    isTaskEditable = false;
                                  } else if (normalizedDate
                                      .isAtSameMomentAs(todayWithoutTime)) {
                                    statusIcon = Icons.access_time;
                                    statusColor = Colors.orange;
                                    isTaskEditable = true;
                                  } else {
                                    statusIcon = Icons.help_outline;
                                    statusColor = Colors.grey;
                                    isTaskEditable = false;
                                  }
                                  isCheckValue =
                                      checkboxStates[event.name] ?? false;

                                  return ListTile(
                                    leading: Icon(statusIcon,
                                        color: statusColor, size: 28),
                                    title: Text(
                                      taskName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    subtitle: Text(
                                      'Status: ${status[0].toUpperCase()}${status.substring(1)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: statusColor,
                                          ),
                                    ),
                                    trailing: Checkbox(
                                      value: isCheckValue, // status == 'done',
                                      onChanged: isTaskEditable
                                          ? (value) {
                                              if (value == true) {
                                                setState(() {
                                                  // status = 'done';
                                                  // isCheckValue = value!;
                                                  checkboxStates[event.name] =
                                                      value ?? false;
                                                });

                                                // Consider dispatching an event to Bloc
                                                // _calendarBloc.add(UpdateTaskStatusEvent(
                                                //     event, 'done'));
                                              } else {
                                                setState(() {
                                                  checkboxStates[event.name] =
                                                      value ?? false;
                                                });
                                              }
                                            }
                                          : null,
                                      activeColor: Colors.green,
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(height: 16.0),
                            // Add Task Button for Current or Future Dates
                            if (!isPastDate)
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final newTaskName =
                                        await _showAddTaskDialog(
                                            context, normalizedDate);
                                    // logger.e(newTaskName);
                                    if (newTaskName != '' &&
                                        newTaskName != null) {
                                      var params = CalendarTaskParams(
                                          dateTimeString:
                                              date.toIso8601String(),
                                          selectedDateString:
                                              date.millisecondsSinceEpoch,
                                          focusDateString:
                                              focusData.toIso8601String(),
                                          taskName: newTaskName);
                                      _calendarBloc
                                          .add(CalendarAddTaskEvent(params));

                                      // Navigator.of(context).pop();
                                    }
                                  },
                                  icon: const Icon(Icons.add,
                                      color: Colors.white),
                                  label: const Text('Add Task'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 20.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8.0),
                            // Close Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.close,
                                    color: Colors.green),
                                label: const Text('Close'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ));
      },
    );
  }
}
