import 'package:json_annotation/json_annotation.dart';
import 'package:workout_tracker/models/exercise_model.dart';

part 'routine_exercise_model.g.dart';

@JsonSerializable()
class RoutineExerciseModel {
  int? id;
  String? name;
  List<ExerciseSerieModel>? exerciseSeries;

  RoutineExerciseModel(
    this.id,
    this.name,
    this.exerciseSeries,
  );

  factory RoutineExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineExerciseModelToJson(this);

  @override
  String toString() {
    return "{Id: $id, Name: $name, Exercises: $exerciseSeries";
  }
}

@JsonSerializable()
class ExerciseSerieModel {
  ExerciseModel exercise;
  double? weight;
  int? repetitions;
  int? restSeconds;

  ExerciseSerieModel(
    this.exercise,
    this.weight,
    this.repetitions,
    this.restSeconds,
  );

  factory ExerciseSerieModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseSerieModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseSerieModelToJson(this);

  @override
  String toString() {
    return "{Exercise: $exercise, Weight: $weight, Repetitions: $repetitions, Rest Seconds: $restSeconds";
  }
}
