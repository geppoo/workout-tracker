// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutineExerciseModel _$RoutineExerciseModelFromJson(
        Map<String, dynamic> json) =>
    RoutineExerciseModel(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      (json['exerciseSeries'] as List<dynamic>?)
          ?.map((e) => ExerciseSerieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoutineExerciseModelToJson(
        RoutineExerciseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'exerciseSeries': instance.exerciseSeries,
    };

ExerciseSerieModel _$ExerciseSerieModelFromJson(Map<String, dynamic> json) =>
    ExerciseSerieModel(
      ExerciseModel.fromJson(json['exercise'] as Map<String, dynamic>),
      (json['weight'] as num?)?.toDouble(),
      (json['repetitions'] as num?)?.toInt(),
      (json['restSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExerciseSerieModelToJson(ExerciseSerieModel instance) =>
    <String, dynamic>{
      'exercise': instance.exercise,
      'weight': instance.weight,
      'repetitions': instance.repetitions,
      'restSeconds': instance.restSeconds,
    };
