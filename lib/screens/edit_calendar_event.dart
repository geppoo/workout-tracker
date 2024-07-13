import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/routine_model.dart';

import '../models/calendar_event_list_model.dart';
import '../models/calendar_event_model.dart';
import '../models/routine_list_model.dart';

class EditCalendarEvent extends StatefulWidget {
  const EditCalendarEvent(
      {super.key, required this.editDate, required this.editEvents});

  final DateTime editDate;

  final List<CalendarEventModel> editEvents;

  @override
  State<EditCalendarEvent> createState() => _EditCalendarEventState();
}

class _EditCalendarEventState extends State<EditCalendarEvent> {
  late final List<CalendarEventModel> _editDayEvents;
  late DateTime _selectedDay;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  late RoutineModel selectedRoutineToAdd;

  @override
  void initState() {
    super.initState();

    _selectedDay = widget.editDate;
    _editDayEvents = widget.editEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarEventListModel>(
      builder: (context, calendarListModel, child) {
        List<CalendarEventModel> kEditEvents = calendarListModel.kEvents
            .where((event) =>
                formatter.format(event.kDay) ==
                formatter.format(widget.editDate))
            .toList();
        return Scaffold(
          appBar: AppBar(
            title:
                Center(child: Text("Day ${formatter.format(widget.editDate)}")),
            actions: [
              IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Add Workout"),
                        content: Consumer<RoutineListModel>(
                          builder: (context, routineListModel, child) {
                            return DropdownMenu<RoutineModel>(
                              dropdownMenuEntries: routineListModel.routines
                                  .map<DropdownMenuEntry<RoutineModel>>(
                                      (RoutineModel routine) {
                                return DropdownMenuEntry<RoutineModel>(
                                  value: routine,
                                  label: routine.name,
                                  style: MenuItemButton.styleFrom(
                                    foregroundColor:
                                        Color(routine.hexIconColor!),
                                    minimumSize: const Size(160, 40),
                                  ),
                                );
                              }).toList(),
                              onSelected: (routine) {
                                setState(() {
                                  selectedRoutineToAdd = routine!;
                                });
                              },
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              calendarListModel
                                  .add(
                                CalendarEventModel(
                                  UniqueKey().hashCode,
                                  _selectedDay,
                                  selectedRoutineToAdd,
                                ),
                              )
                                  .then((voidValue) {
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.event_rounded),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: kEditEvents.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  onTap: () {},
                  title: Text(kEditEvents[index].routineSerie.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.event_busy_rounded),
                    onPressed: () {
                      calendarListModel.remove(kEditEvents[index]);
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
