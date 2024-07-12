// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarEventModel _$CalendarEventModelFromJson(Map<String, dynamic> json) =>
    CalendarEventModel(
      (json['id'] as num).toInt(),
      DateTime.parse(json['kDay'] as String),
      RoutineModel.fromJson(json['routineSerie'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CalendarEventModelToJson(CalendarEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kDay': instance.kDay.toIso8601String(),
      'routineSerie': instance.routineSerie,
    };
