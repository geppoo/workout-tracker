import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workout_tracker/models/screen_model.dart';

import '../models/calendar_event_list_model.dart';
import '../models/calendar_event_model.dart';
import '../theme/theme_provider.dart';
import '../utils/calendar_util.dart';

class Calendar extends StatefulWidget implements ScreenModel {
  Calendar({super.key, required this.context});

  @override
  State<Calendar> createState() => _CalendarState();

  @override
  final BuildContext context;

  @override
  late final Widget floatingActionButton = FloatingActionButton(
    child: const Icon(Icons.edit_calendar_rounded),
    onPressed: () {
      //showAlertDialog(context);
      //TODO: implementare apertura pagina per modifica eventi del giorno
    },
  );

  @override
  set context(BuildContext context) {
    this.context = context;
  }

  @override
  set floatingActionButton(Widget floatingActionButton) {
    this.floatingActionButton = floatingActionButton;
  }

  static void showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Calendar"),
      content: const Text("Calendar yay!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class _CalendarState extends State<Calendar> {
  late final ValueNotifier<List<CalendarEventModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<CalendarEventModel> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEventList[day] ?? [];
  }

  List<CalendarEventModel> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarEventListModel>(
      builder: (context, calendarListModel, child) {
        // Setto tutti gli eventi letti dal provider
        setKEvents(calendarListModel.kEvents);
        return Column(
          children: [
            TableCalendar<CalendarEventModel>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
                selectedDecoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context)
                      .themeData
                      .colorScheme
                      .tertiaryContainer,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  color: Provider.of<ThemeProvider>(context)
                      .themeData
                      .colorScheme
                      .onTertiaryContainer,
                ),
                todayDecoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context)
                      .themeData
                      .colorScheme
                      .secondaryContainer,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                    color: Provider.of<ThemeProvider>(context)
                        .themeData
                        .colorScheme
                        .onSecondaryContainer),
                rangeStartDecoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context)
                      .themeData
                      .colorScheme
                      .inversePrimary,
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context)
                      .themeData
                      .colorScheme
                      .inversePrimary,
                  shape: BoxShape.circle,
                ),
                rangeHighlightColor: Provider.of<ThemeProvider>(context)
                    .themeData
                    .colorScheme
                    .primaryContainer,
                markerDecoration: const BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<CalendarEventModel>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
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
                          onTap: () => developer.log('${value[index]}'),
                          title: Text('${value[index].id}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
