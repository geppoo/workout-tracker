// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutineExerciseModel _$RoutineExerciseModelFromJson(
        Map<String, dynamic> json) =>
    RoutineExerciseModel(
      (json['exerciseId'] as num?)?.toInt(),
      (json['exerciseSeries'] as List<dynamic>?)
          ?.map((e) => ExerciseSerieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoutineExerciseModelToJson(
        RoutineExerciseModel instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'exerciseSeries': instance.exerciseSeries,
    };

ExerciseSerieModel _$ExerciseSerieModelFromJson(Map<String, dynamic> json) =>
    ExerciseSerieModel(
      (json['weight'] as num?)?.toDouble(),
      (json['repetitions'] as num?)?.toInt(),
      (json['restSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExerciseSerieModelToJson(ExerciseSerieModel instance) =>
    <String, dynamic>{
      'weight': instance.weight,
      'repetitions': instance.repetitions,
      'restSeconds': instance.restSeconds,
    };
