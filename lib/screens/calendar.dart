import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/calendar_event_list_model.dart';
import '../models/calendar_event_model.dart';
import '../theme/theme_provider.dart';
import '../widgets/bottom_navbar.dart';
import 'edit_calendar_event.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late List<CalendarEventModel> _selectedEvents = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by long-pressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late LinkedHashMap<DateTime, List<CalendarEventModel>> kEventList =
      LinkedHashMap<DateTime, List<CalendarEventModel>>(
    equals: compareDays,
    hashCode: getHashCode,
  );
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final kToday = DateTime.now();
  final kFirstDay = DateTime(2020, DateTime.january);
  final kLastDay = DateTime(DateTime.now().year, DateTime.now().month + 3, 15);

  DateTime _editDate = DateTime.now();
  List<CalendarEventModel> _editEvents = [];

  @override
  void initState() {
    super.initState();
  }

  DateTime dateOnly(DateTime dateTime) {
    if (dateTime.isUtc) {
      return DateTime.utc(dateTime.year, dateTime.month, dateTime.day);
    } else {
      return DateTime(dateTime.year, dateTime.month, dateTime.day);
    }
  }

  void setKEvents(List<CalendarEventModel> kEvents) {
    kEventList.clear();
    for (var event in kEvents) {
      (kEventList[dateOnly(event.kDay)] ??= []).add(event);
    }
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  bool compareDays(DateTime? d1, DateTime d2) {
    return d1?.year == d2.year && d1?.month == d2.month && d1?.day == d2.day;
  }

  List<CalendarEventModel> _getEventsForDay(DateTime day) {
    return kEventList[day] ?? [];
  }

  List<CalendarEventModel> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!compareDays(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
    }
    _selectedEvents = _getEventsForDay(selectedDay);

    setState(() {
      _editDate = selectedDay;
      _editEvents = _selectedEvents;
    });
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
      _selectedEvents = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CalendarEventListModel>(
        builder: (context, calendarListModel, child) {
          // Init vars
          setKEvents(calendarListModel.kEvents);
          _selectedDay = _focusedDay;
          _selectedEvents = _getEventsForDay(_selectedDay!);
          return Column(
            children: [
              TableCalendar<CalendarEventModel>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => compareDays(_selectedDay, day),
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
                        .onSecondaryContainer,
                  ),
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
                  markerDecoration: BoxDecoration(
                    color: Provider.of<ThemeProvider>(context)
                        .themeData
                        .colorScheme
                        .inverseSurface,
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 5,
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
                child: ListView.builder(
                  itemCount: _selectedEvents.length,
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
                        title: Text(_selectedEvents[index].routineSerie.name),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit_calendar_rounded),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EditCalendarEvent(
                editDate: _editDate,
                editEvents: _editEvents,
              ),
            ),
          );
        },
      ),
    );
  }
}
