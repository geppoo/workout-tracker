// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutineModel _$RoutineModelFromJson(Map<String, dynamic> json) => RoutineModel(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      (json['hexIconColor'] as num?)?.toInt(),
      (json['routineExercises'] as List<dynamic>?)
          ?.map((e) => RoutineExerciseModel.fromJson(e as Map<String, dynamic>))
          .toSet(),
    );

Map<String, dynamic> _$RoutineModelToJson(RoutineModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'hexIconColor': instance.hexIconColor,
      'routineExercises': instance.routineExercises?.toList(),
    };