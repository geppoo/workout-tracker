import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:workout_tracker/models/calendar_event_model.dart';

import '../services/file_service.dart';

class CalendarEventListModel extends ChangeNotifier {
  static final CalendarEventListModel _singleton =
      CalendarEventListModel._internal();

  factory CalendarEventListModel() {
    return _singleton;
  }

  CalendarEventListModel._internal();

  List<CalendarEventModel> _kEvents = [];

  UnmodifiableListView<CalendarEventModel> get kEvents =>
      UnmodifiableListView(_kEvents);

  set _setKEvents(list) {
    _kEvents = list;
  }

  Future<void> init() async {
    Iterable data = [];
    await FileService.calendar().readFile().then((fileContent) {
      fileContent ?? (fileContent = "[]");
      data = jsonDecode(fileContent);
    });

    _setKEvents = List<CalendarEventModel>.from(
        data.map((model) => CalendarEventModel.fromJson(model)));
  }

  Future<void> add(CalendarEventModel kEvent) async {
    _kEvents.add(kEvent);
    await FileService.calendar()
        .writeFile(jsonEncode(_kEvents))
        .then((success) {
      notifyListeners();
    });
  }

  Future<void> setAt(int index, CalendarEventModel kEvent) async {
    _kEvents[index] = kEvent;
    await FileService.calendar()
        .writeFile(jsonEncode(_kEvents))
        .then((success) {
      notifyListeners();
    });
  }

  Future<void> removeAt(int index) async {
    _kEvents.removeAt(index);
    await FileService.calendar()
        .writeFile(jsonEncode(_kEvents))
        .then((success) {
      notifyListeners();
    });
  }
  
  Future<void> remove(CalendarEventModel kEvent) async {
    _kEvents.remove(kEvent);
    await FileService.calendar()
        .writeFile(jsonEncode(_kEvents))
        .then((success) {
      notifyListeners();
    });
}

  Future<void> removeAll() async {
    _kEvents.clear();
    await FileService.calendar()
        .writeFile(jsonEncode(_kEvents))
        .then((success) {
      notifyListeners();
    });
  }

  @override
  String toString() {
    return _kEvents.toString();
  }
}
