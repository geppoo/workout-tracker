import 'package:json_annotation/json_annotation.dart';

import '../constants/equipment.dart';
import '../constants/exercise_type.dart';
import '../constants/muscle_groups.dart';

part 'exercise_model.g.dart';

@JsonSerializable()
class ExerciseModel {
  late final int id;
  String? imagePath1;
  String? imagePath2;
  String name;
  String? description;
  ExerciseType type;
  List<MuscleGroups>? mainMuscleGroups;
  List<MuscleGroups>? supportMuscleGroups;
  List<Equipment>? equipment;
  String? notes;

  ExerciseModel(
    this.id,
    this.imagePath1,
    this.imagePath2,
    this.name,
    this.type,
    this.mainMuscleGroups,
    this.supportMuscleGroups,
    this.description,
    this.equipment,
    this.notes,
  );

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseModelToJson(this);

  @override
  String toString() {
    return "{Id: $id, Image 1: $imagePath1, Image 2: $imagePath2, Name: $name, Description: $description, Type: $type, Main Muscle Groups: $mainMuscleGroups, Support Muscle Groups: $supportMuscleGroups, Equipment: $equipment, Notes: $notes}";
  }
}
