// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarEventModel _$CalendarEventModelFromJson(Map<String, dynamic> json) =>
    CalendarEventModel(
      (json['id'] as num).toInt(),
      DateTime.parse(json['kDay'] as String),
      (json['exerciseId'] as num).toInt(),
    );

Map<String, dynamic> _$CalendarEventModelToJson(CalendarEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kDay': instance.kDay.toIso8601String(),
      'exerciseId': instance.exerciseId,
    };
