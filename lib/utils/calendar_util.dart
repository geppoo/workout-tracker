import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';
import "package:collection/collection.dart";

import '../models/calendar_event_model.dart';

var kEventList = LinkedHashMap<DateTime, List<CalendarEventModel>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

void setKEvents(List<CalendarEventModel> kEvents) {
  kEventList.addAll(groupBy(kEvents, (kEvent) => kEvent.kDay));
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

final kToday = DateTime.now();
final kFirstDay = DateTime(2020, DateTime.january);
final kLastDay = DateTime(kToday.year, kToday.month + 3, 15);
