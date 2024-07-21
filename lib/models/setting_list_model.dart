import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:workout_tracker/models/setting_model.dart';

import '../services/file_service.dart';

class SettingListModel extends ChangeNotifier {
  static final SettingListModel _singleton = SettingListModel._internal();

  factory SettingListModel() {
    return _singleton;
  }

  SettingListModel._internal();

  List<SettingModel> _settings = [];

  UnmodifiableListView<SettingModel> get settings =>
      UnmodifiableListView(_settings);

  set _setSettings(list) {
    _settings = list;
  }

  Future<void> init() async {
    Iterable data = [];
    await FileService.settings().readFile().then((fileContent) {
      fileContent ?? (fileContent = "[]");
      data = jsonDecode(fileContent);
    });

    _setSettings = List<SettingModel>.from(
        data.map((model) => SettingModel.fromJson(model)));
  }

  Future<void> add(SettingModel setting) async {
    _settings.add(setting);
    await FileService.settings()
        .writeFile(jsonEncode(_settings))
        .then((success) {
      notifyListeners();
    });
  }

  Future<void> setAt(int index, SettingModel setting) async {
    _settings[index] = setting;
    await FileService.settings()
        .writeFile(jsonEncode(_settings))
        .then((success) {
      notifyListeners();
    });
  }

  Future<void> removeAt(int index) async {
    _settings.removeAt(index);
    await FileService.settings()
        .writeFile(jsonEncode(_settings))
        .then((success) {
      notifyListeners();
    });
  }

  Future<void> remove(SettingModel setting) async {
    _settings.remove(setting);
    await FileService.settings()
        .writeFile(jsonEncode(_settings))
        .then((success) {
      notifyListeners();
    });
  }

  Future<void> removeAll() async {
    _settings.clear();
    await FileService.settings()
        .writeFile(jsonEncode(_settings))
        .then((success) {
      notifyListeners();
    });
  }

  @override
  String toString() {
    return _settings.toString();
  }
}
