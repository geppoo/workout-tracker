import 'dart:collection';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:workout_tracker/models/exercise_model.dart';

import '../services/file_service.dart';

class ExerciseListModel extends ChangeNotifier {
  static final ExerciseListModel _singleton = ExerciseListModel._internal();

  factory ExerciseListModel() {
    return _singleton;
  }

  ExerciseListModel._internal();

  List<ExerciseModel> _exercises = [];

  UnmodifiableListView<ExerciseModel> get exercises =>
      UnmodifiableListView(_exercises);

  set _setExercises(list) {
    _exercises = list;
  }

  Future<void> init() async {
    Iterable data = [];
    await FileService.exercises().readFile().then((fileContent) {
      fileContent ?? (fileContent = "[]");
      data = jsonDecode(fileContent);
    });

    _setExercises = List<ExerciseModel>.from(
        data.map((model) => ExerciseModel.fromJson(model)));
  }

  Future<void> add(ExerciseModel exercise) async {
    _exercises.add(exercise);
    await FileService.exercises()
        .writeFile(jsonEncode(_exercises))
        .then((success) {
      notifyListeners();
    });
  }

  Future<void> setAt(int index, ExerciseModel exercise) async {
    _exercises[index] = exercise;
    await FileService.exercises()
        .writeFile(jsonEncode(_exercises))
        .then((success) {
      notifyListeners();
    });
  }

  Future<void> removeAt(int index) async {
    _exercises.removeAt(index);
    await FileService.exercises()
        .writeFile(jsonEncode(_exercises))
        .then((success) {
      notifyListeners();
    });
  }

  Future<void> removeAll() async {
    _exercises.clear();
    await FileService.exercises()
        .writeFile(jsonEncode(_exercises))
        .then((success) {
      notifyListeners();
    });
  }

  @override
  String toString() {
    return _exercises.toString();
  }
}
