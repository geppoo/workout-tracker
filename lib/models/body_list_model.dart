import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../services/file_service.dart';
import 'body_model.dart';

class BodyListModel extends ChangeNotifier {
  static final BodyListModel _singleton = BodyListModel._internal();

  factory BodyListModel() {
    return _singleton;
  }

  BodyListModel._internal();

  List<BodyModel> _bodyTrack = [];

  UnmodifiableListView<BodyModel> get bodyTrack =>
      UnmodifiableListView(_bodyTrack);

  set _setKEvents(list) {
    _bodyTrack = list;
  }

  Future<void> init() async {
    Iterable data = [];
    await FileService.body().readFile().then((fileContent) {
      fileContent ?? (fileContent = "[]");
      data = jsonDecode(fileContent);
    });

    _setKEvents =
        List<BodyModel>.from(data.map((model) => BodyModel.fromJson(model)));
  }

  Future<void> add(BodyModel bodyTrack) async {
    _bodyTrack.add(bodyTrack);
    await FileService.body().writeFile(jsonEncode(_bodyTrack)).then((success) {
      notifyListeners();
    });
  }

  Future<void> setAt(int index, BodyModel bodyTrack) async {
    _bodyTrack[index] = bodyTrack;
    await FileService.body().writeFile(jsonEncode(_bodyTrack)).then((success) {
      notifyListeners();
    });
  }

  Future<void> removeAt(int index) async {
    _bodyTrack.removeAt(index);
    await FileService.body().writeFile(jsonEncode(_bodyTrack)).then((success) {
      notifyListeners();
    });
  }

  Future<void> remove(BodyModel bodyTrack) async {
    _bodyTrack.remove(bodyTrack);
    await FileService.body().writeFile(jsonEncode(_bodyTrack)).then((success) {
      notifyListeners();
    });
  }

  Future<void> removeAll() async {
    _bodyTrack.clear();
    await FileService.body().writeFile(jsonEncode(_bodyTrack)).then((success) {
      notifyListeners();
    });
  }

  @override
  String toString() {
    return _bodyTrack.toString();
  }
}
