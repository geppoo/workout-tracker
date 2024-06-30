import 'package:json_annotation/json_annotation.dart';

part 'routine_exercise_model.g.dart';

@JsonSerializable()
class RoutineExerciseModel {
  int? exerciseId;
  List<ExerciseSerieModel>? exerciseSeries;

  RoutineExerciseModel(
    this.exerciseId,
    this.exerciseSeries,
  );

  factory RoutineExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineExerciseModelToJson(this);

  @override
  String toString() {
    return "{Exercise Id: $exerciseId, Exercises: $exerciseSeries";
  }
}

@JsonSerializable()
class ExerciseSerieModel {
  double? weight;
  int? repetitions;
  int? restSeconds;

  ExerciseSerieModel(
    this.weight,
    this.repetitions,
    this.restSeconds,
  );

  factory ExerciseSerieModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseSerieModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseSerieModelToJson(this);

  @override
  String toString() {
    return "{Weight: $weight, Repetitions: $repetitions, Rest Seconds: $restSeconds";
  }
}
