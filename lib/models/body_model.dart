import 'package:json_annotation/json_annotation.dart';

part 'body_model.g.dart';

@JsonSerializable()
class BodyModel {
  final int id;
  final double weight;
  final double height;
  final double fatMass;
  final double leanMass;
  final double water;

  BodyModel(this.id, this.weight, this.height, this.fatMass, this.leanMass, this.water);

  factory BodyModel.fromJson(Map<String, dynamic> json) =>
      _$BodyModelFromJson(json);

  Map<String, dynamic> toJson() => _$BodyModelToJson(this);
}