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

  void add(RoutineModel item) {
    _routines.add(item);
    notifyListeners();
  }

  void removeAt(int index) {
    _routines.removeAt(index);
    notifyListeners();
  }

  void removeAll() {
    _routines.clear();
    notifyListeners();
  }

  @override
  String toString() {
    return _routines.toString();
  }
}
