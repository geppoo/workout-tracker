// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) =>
    ExerciseModel(
      (json['id'] as num?)?.toInt(),
      json['imagePath1'] as String?,
      json['imagePath2'] as String?,
      json['name'] as String?,
      $enumDecodeNullable(_$ExerciseTypeEnumMap, json['type']),
      (json['mainMuscleGroups'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$MuscleGroupsEnumMap, e))
          .toList(),
      (json['supportMuscleGroups'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$MuscleGroupsEnumMap, e))
          .toList(),
      json['description'] as String?,
      (json['equipment'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$EquipmentEnumMap, e))
          .toList(),
      json['notes'] as String?,
    );

Map<String, dynamic> _$ExerciseModelToJson(ExerciseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imagePath1': instance.imagePath1,
      'imagePath2': instance.imagePath2,
      'name': instance.name,
      'description': instance.description,
      'type': _$ExerciseTypeEnumMap[instance.type],
      'mainMuscleGroups': instance.mainMuscleGroups
          ?.map((e) => _$MuscleGroupsEnumMap[e]!)
          .toList(),
      'supportMuscleGroups': instance.supportMuscleGroups
          ?.map((e) => _$MuscleGroupsEnumMap[e]!)
          .toList(),
      'equipment':
          instance.equipment?.map((e) => _$EquipmentEnumMap[e]!).toList(),
      'notes': instance.notes,
    };

const _$ExerciseTypeEnumMap = {
  ExerciseType.conPesi: 'Allenamento con i Pesi',
  ExerciseType.corpoLiberoRipetizioni:
      'Allenamento a Corpo Libero (Ripetizioni)',
  ExerciseType.corpoLiberoDurata: 'Allenamento a Corpo Libero (Durata)',
  ExerciseType.cardioDistanza: 'Cardio (Distanza)',
  ExerciseType.cardioDurata: 'Cardio (Durata)',
};

const _$MuscleGroupsEnumMap = {
  MuscleGroups.petto: 'petto',
  MuscleGroups.dorso: 'dorso',
  MuscleGroups.spalle: 'spalle',
  MuscleGroups.bicipiti: 'bicipiti',
  MuscleGroups.tricipiti: 'tricipiti',
  MuscleGroups.polpacci: 'polpacci',
  MuscleGroups.addome: 'addome',
  MuscleGroups.trapezio: 'trapezio',
  MuscleGroups.avambraccio: 'avambraccio',
  MuscleGroups.glutei: 'glutei',
  MuscleGroups.quadricipiti: 'quadricipiti',
  MuscleGroups.bicipitiFemorali: 'bicipitiFemorali',
  MuscleGroups.cardio: 'cardio',
};

const _$EquipmentEnumMap = {
  Equipment.macchinario: 'Macchinario',
  Equipment.bilanciere: 'Bilanciere',
  Equipment.bilanciereEz: 'Bilanciere EZ',
  Equipment.manubri: 'Manubri',
  Equipment.corpo: 'Corpo',
  Equipment.pesoDisco: 'Peso a disco',
  Equipment.barra: 'Barra',
  Equipment.corda: 'Corda',
  Equipment.elastico: 'Elastico',
  Equipment.panca: 'Panca',
  Equipment.supporto: 'Supporto',
};
