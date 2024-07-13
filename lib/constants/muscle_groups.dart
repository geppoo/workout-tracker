

enum MuscleGroups {
  petto,
  dorso,
  spalle,
  bicipiti,
  tricipiti,
  polpacci,
  addome,
  trapezio,
  avambraccio,
  glutei,
  quadricipiti,
  bicipitiFemorali,
  cardio;

  static MuscleGroups? fromString(String s) => switch (s) {
        "Petto" => petto,
        "Dorso" => dorso,
        "Spalle" => spalle,
        "Bicipiti" => bicipiti,
        "Tricipiti" => tricipiti,
        "Polpacci" => polpacci,
        "Addome" => addome,
        "Trapezio" => trapezio,
        "Avambraccio" => avambraccio,
        "Glutei" => glutei,
        "Quadricipiti" => quadricipiti,
        "Bicipiti Femorali" => bicipitiFemorali,
        "Cardio" => cardio,
        _ => null
      };

  static String? fromMuscleGroup(MuscleGroups muscleGroup) =>
      switch (muscleGroup) {
        petto => "Petto",
        dorso => "Dorso",
        spalle => "Spalle",
        bicipiti => "Bicipiti",
        tricipiti => "Tricipiti",
        polpacci => "Polpacci",
        addome => "Addome",
        trapezio => "Trapezio",
        avambraccio => "Avambraccio",
        glutei => "Glutei",
        quadricipiti => "Quadricipiti",
        bicipitiFemorali => "Bicipiti Femorali",
        cardio => "Cardio"
      };
}
