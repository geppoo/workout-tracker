// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyModel _$BodyModelFromJson(Map<String, dynamic> json) => BodyModel(
      (json['id'] as num).toInt(),
      (json['weight'] as num).toDouble(),
      (json['height'] as num).toDouble(),
      (json['fatMass'] as num).toDouble(),
      (json['leanMass'] as num).toDouble(),
      (json['water'] as num).toDouble(),
    );

Map<String, dynamic> _$BodyModelToJson(BodyModel instance) => <String, dynamic>{
      'id': instance.id,
      'weight': instance.weight,
      'height': instance.height,
      'fatMass': instance.fatMass,
      'leanMass': instance.leanMass,
      'water': instance.water,
    };