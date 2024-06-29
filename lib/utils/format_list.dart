import 'package:workout_tracker/constants/equipment.dart';

import '../constants/muscle_groups.dart';

class FormatList {
  static String formatMuscleGroupList(List<MuscleGroups>? list) {
    String retval = "";
    if (list != null) {
      for (var value in list) {
        retval = "$retval${MuscleGroups.fromMuscleGroup(value)!}, ";
      }
    }

    if (retval.lastIndexOf(", ") != -1) {
      retval = retval.replaceRange(retval.lastIndexOf(", "), null, "");
    }

    return retval;
  }

  static String formatEquipmentList(List<Equipment>? list) {
    String retval = "";
    if (list != null) {
      for (var value in list) {
        retval = "$retval${Equipment.fromEquipment(value)!}, ";
      }
    }

    if (retval.lastIndexOf(", ") != -1) {
      retval = retval.replaceRange(retval.lastIndexOf(", "), null, "");
    }

    return retval;
  }

  static String formatStringList(List<String>? list) {
    String retval = "";
    if (list != null) {
      retval = list.join(", ");
    }

    return retval.replaceAll("[", "").replaceAll("]", "");
  }
}
