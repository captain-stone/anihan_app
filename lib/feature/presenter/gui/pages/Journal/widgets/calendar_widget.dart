import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../blocs/calendar_bloc.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
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
              return state.events[normalizedDay] ?? [];
            },
            onDaySelected: (selectedDay, focusedDay) {
              // Dispatch the SelectDateEvent to update the selected and focused dates
              context
                  .read<CalendarBloc>()
                  .add(SelectDateEvent(selectedDay, focusedDay));
            },
            onPageChanged: (focusedDay) {
              // Dispatch the SelectDateEvent when the page (month) changes
              context
                  .read<CalendarBloc>()
                  .add(SelectDateEvent(focusedDay, focusedDay));
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10.0),
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
              ),
              markerDecoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              markersMaxCount: 3,
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
                      children: events.take(3).map((event) {
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
      },
    );
  }

  void _showAddTaskDialog(BuildContext context, DateTime date) {
    final TextEditingController taskNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: taskNameController,
            decoration: const InputDecoration(
              labelText: 'Task Name',
              hintText: 'Enter task name',
              prefixIcon: Icon(Icons.task),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String taskName = taskNameController.text.trim();
                if (taskName.isNotEmpty) {
                  context
                      .read<CalendarBloc>()
                      .add(AddTaskEvent(date, taskName));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  bool _isDialogOpen = false;
  // Function to show the event dialog
  void _showEventDialog(BuildContext context, DateTime date,
      Map<DateTime, List<Map<String, String>>> events) {
    final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    final eventList = events[normalizedDate] ?? [];
    final DateTime today = DateTime.now();
    bool isPastDate =
        normalizedDate.isBefore(DateTime(today.year, today.month, today.day));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 16.0),
                    // List of Tasks
                    if (eventList.isNotEmpty)
                      ...eventList.map((event) {
                        final String taskName = event['name'] ?? 'Unnamed Task';
                        String status = event['status'] ?? 'upcoming';
                        IconData statusIcon;
                        Color statusColor;
                        bool isTaskEditable = false;

                        // Determine task status and icon
                        if (status == 'done') {
                          statusIcon = Icons.check_circle;
                          statusColor = Colors.green;
                          isTaskEditable = false;
                        } else if (status == 'missed') {
                          statusIcon = Icons.error;
                          statusColor = Colors.red;
                          isTaskEditable = false;
                        } else if (normalizedDate.isAtSameMomentAs(today)) {
                          statusIcon = Icons.access_time;
                          statusColor = Colors.orange;
                          isTaskEditable = true;
                        } else {
                          statusIcon = Icons.help_outline;
                          statusColor = Colors.grey;
                          isTaskEditable = false;
                        }

                        return ListTile(
                          leading:
                              Icon(statusIcon, color: statusColor, size: 28),
                          title: Text(
                            taskName,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                            value: status == 'done',
                            onChanged: isTaskEditable
                                ? (value) {
                                    if (value == true) {
                                      setState(() {
                                        event['status'] = 'done';
                                      });
                                    }
                                  }
                                : null,
                            activeColor: Colors.green,
                          ),
                        );
                      }).toList(),
                    const SizedBox(height: 16.0),
                    // Add Task Button for Current or Future Dates
                    if (!isPastDate)
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _showAddTaskDialog(context, normalizedDate),
                          icon: const Icon(Icons.add, color: Colors.white),
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
                        icon: const Icon(Icons.close, color: Colors.green),
                        label: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
