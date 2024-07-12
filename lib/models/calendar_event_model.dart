import 'package:json_annotation/json_annotation.dart';
import 'package:workout_tracker/models/routine_model.dart';

part 'calendar_event_model.g.dart';

@JsonSerializable()
class CalendarEventModel {
  final int id;
  final DateTime kDay;
  final RoutineModel routineSerie;

  CalendarEventModel(this.id, this.kDay, this.routineSerie);

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarEventModelToJson(this);

  @override
  String toString() => "id: $id, kDay: $kDay, exerciseId: $routineSerie";
}
