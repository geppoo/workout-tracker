import 'package:json_annotation/json_annotation.dart';

enum ExerciseType {
  @JsonValue("Allenamento con i Pesi")
  conPesi,
  @JsonValue("Allenamento a Corpo Libero (Ripetizioni)")
  corpoLiberoRipetizioni,
  @JsonValue("Allenamento a Corpo Libero (Durata)")
  corpoLiberoDurata,
  @JsonValue("Cardio (Distanza)")
  cardioDistanza,
  @JsonValue("Cardio (Durata)")
  cardioDurata;

  static ExerciseType? fromString(String s) => switch (s) {
        "Allenamento con i Pesi" => conPesi,
        "Allenamento a Corpo Libero (Ripetizioni)" => corpoLiberoRipetizioni,
        "Allenamento a Corpo Libero (Durata)" => corpoLiberoDurata,
        "Cardio (Distanza)" => cardioDistanza,
        "Cardio (Durata)" => cardioDurata,
        _ => null
      };

  static String? fromExerciseType(ExerciseType exercise) => switch (exercise) {
        conPesi => "Allenamento con i Pesi",
        corpoLiberoRipetizioni => "Allenamento a Corpo Libero (Ripetizioni)",
        corpoLiberoDurata => "Allenamento a Corpo Libero (Durata)",
        cardioDistanza => "Cardio (Distanza)",
        cardioDurata => "Cardio (Durata)",
      };
}
