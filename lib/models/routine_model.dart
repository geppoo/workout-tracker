import 'package:json_annotation/json_annotation.dart';
import 'package:workout_tracker/models/routine_exercise_model.dart';

part 'routine_model.g.dart';

@JsonSerializable()
class RoutineModel {
  int? id;
  String? name;
  int? hexIconColor;
  RoutineExerciseModel? routineExerciseModel;

  RoutineModel(
    this.id,
    this.name,
    this.hexIconColor,
    this.routineExerciseModel,
  );

  factory RoutineModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineModelToJson(this);

  @override
  String toString() {
    return "{Id: $id, Name: $name, HexIconColor: $hexIconColor, Exercises: $routineExerciseModel";
  }
}
