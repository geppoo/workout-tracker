// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

import '../models/calendar_event_model.dart';

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<CalendarEventModel>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

//TODO implementare lettura eventi da file
final _kEventSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5):
        List.generate(item % 4 + 1, (index) => CalendarEventModel(1, DateTime.now(), index + 1))
}..addAll({
    kToday: [
      CalendarEventModel(2, DateTime.now(), 3),
      CalendarEventModel(3, DateTime.now(), 4),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
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
