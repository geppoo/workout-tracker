import 'package:json_annotation/json_annotation.dart';

enum Equipment {
  @JsonValue("Macchinario")
  macchinario,
  @JsonValue("Bilanciere")
  bilanciere,
  @JsonValue("Bilanciere EZ")
  bilanciereEz,
  @JsonValue("Manubri")
  manubri,
  @JsonValue("Corpo")
  corpo,
  @JsonValue("Peso a disco")
  pesoDisco,
  @JsonValue("Barra")
  barra,
  @JsonValue("Corda")
  corda,
  @JsonValue("Elastico")
  elastico,
  @JsonValue("Panca")
  panca,
  @JsonValue("Supporto")
  supporto;

  static Equipment? fromString(String s) => switch (s) {
        "Macchinario" => macchinario,
        "Bilanciere" => bilanciere,
        "Bilanciere EZ" => bilanciereEz,
        "Manubri" => manubri,
        "Corpo" => corpo,
        "Peso a disco" => pesoDisco,
        "Barra" => barra,
        "Corda" => corda,
        "Elastico" => elastico,
        "Panca" => panca,
        "Supporto" => supporto,
        _ => null
      };

  static String? fromEquipment(Equipment equipment) => switch (equipment) {
        macchinario => "Macchinario",
        bilanciere => "Bilanciere",
        bilanciereEz => "Bilanciere EZ",
        manubri => "Manubri",
        corpo => "Corpo",
        pesoDisco => "Peso a disco",
        barra => "Barra",
        corda => "Corda",
        elastico => "Elastico",
        panca => "Panca",
        supporto => "Supporto",
      };
}
