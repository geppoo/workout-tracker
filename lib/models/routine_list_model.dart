import 'dart:collection';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:workout_tracker/models/routine_model.dart';

import '../services/file_service.dart';

class RoutineListModel extends ChangeNotifier {
  static final RoutineListModel _singleton = RoutineListModel._internal();

  factory RoutineListModel() {
    return _singleton;
  }

  RoutineListModel._internal();

  List<RoutineModel> _routines = [];

  UnmodifiableListView<RoutineModel> get routines =>
      UnmodifiableListView(_routines);

  set _setRoutines(list) {
    _routines = list;
  }

  Future<void> init() async {
    Iterable data = [];
    await FileService.routines().readFile().then((fileContent) {
      fileContent ?? (fileContent = "[]");
      data = jsonDecode(fileContent);
    });

    _setRoutines = List<RoutineModel>.from(
        data.map((model) => RoutineModel.fromJson(model)));
  }

  Future<void> add(RoutineModel routine) async {
    _routines.add(routine);
    await FileService.routines()
        .writeFile(jsonEncode(_routines))
        .then((success) {
      notifyListeners();
    });
  }

  Future<void> setAt(int index, RoutineModel routine) async {
    _routines[index] = routine;
    await FileService.routines()
        .writeFile(jsonEncode(_routines))
        .then((success) {
      notifyListeners();
    });
  }

  Future<void> removeAt(int index) async {
    _routines.removeAt(index);
    await FileService.routines()
        .writeFile(jsonEncode(_routines))
        .then((success) {
      notifyListeners();
    });
  }

  Future<void> removeAll() async {
    _routines.clear();
    await FileService.routines()
        .writeFile(jsonEncode(_routines))
        .then((success) {
      notifyListeners();
    });
  }

  @override
  String toString() {
    return _routines.toString();
  }
}
