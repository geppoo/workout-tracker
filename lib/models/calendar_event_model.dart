import 'package:json_annotation/json_annotation.dart';

part 'calendar_event_model.g.dart';

@JsonSerializable()
class CalendarEventModel {
  final int id;
  final DateTime kDay;
  final int exerciseId;

  CalendarEventModel(this.id, this.kDay, this.exerciseId);

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarEventModelToJson(this);

  @override
  String toString() => "id: $id, kDay: $kDay, exerciseId: $exerciseId";
}
