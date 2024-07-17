import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/constants/equipment.dart';
import 'package:workout_tracker/constants/exercise_type.dart';
import 'package:workout_tracker/constants/muscle_groups.dart';
import 'package:workout_tracker/models/exercise_model.dart';
import 'package:workout_tracker/widgets/custom_dialog.dart';

import '../models/exercise_list_model.dart';
import '../theme/theme_provider.dart';
import '../utils/format_list.dart';

class EditExercise extends StatefulWidget {
  const EditExercise({super.key, required this.exercise});

  final ExerciseModel exercise;

  @override
  State<EditExercise> createState() => _EditExerciseState();
}

class _EditExerciseState extends State<EditExercise> {
  static const listTilePadding =
      EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10);

  List<XFile> images = [];
  List<String> typeList = [];
  List<String> muscleGroups = [];
  List<String> equipments = [];
  var selectedMainMuscleGroups = [];
  var selectedSupportMuscleGroups = [];
  var selectedEquipment = [];

  late TextEditingController nameController = TextEditingController();
  late TextEditingController typeController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController mainMuscleGroupsController =
      TextEditingController();
  late TextEditingController supportMuscleGroupsController =
      TextEditingController();
  late TextEditingController equipmentController = TextEditingController();
  late TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var exercise in ExerciseType.values) {
      typeList.add(ExerciseType.fromExerciseType(exercise)!);
    }

    for (var muscleGroup in MuscleGroups.values) {
      muscleGroups.add(MuscleGroups.fromMuscleGroup(muscleGroup)!);
    }

    for (var equipment in Equipment.values) {
      equipments.add(Equipment.fromEquipment(equipment)!);
    }

    if (widget.exercise.mainMuscleGroups != null) {
      for (var muscle in widget.exercise.mainMuscleGroups!) {
        selectedMainMuscleGroups.add(MuscleGroups.fromMuscleGroup(muscle));
      }
    }

    if (widget.exercise.supportMuscleGroups != null) {
      for (var muscle in widget.exercise.supportMuscleGroups!) {
        selectedSupportMuscleGroups.add(MuscleGroups.fromMuscleGroup(muscle));
      }
    }

    if (widget.exercise.equipment != null) {
      for (var equipment in widget.exercise.equipment!) {
        selectedEquipment.add(Equipment.fromEquipment(equipment));
      }
    }

    nameController = TextEditingController(text: widget.exercise.name);
    typeController = TextEditingController(
        text: ExerciseType.fromExerciseType(widget.exercise.type));
    descriptionController =
        TextEditingController(text: widget.exercise.description);
    mainMuscleGroupsController = TextEditingController(
        text:
            FormatList.formatMuscleGroupList(widget.exercise.mainMuscleGroups));
    supportMuscleGroupsController = TextEditingController(
        text: FormatList.formatMuscleGroupList(
            widget.exercise.supportMuscleGroups));
    equipmentController = TextEditingController(
        text: FormatList.formatEquipmentList(widget.exercise.equipment));
    notesController = TextEditingController(text: widget.exercise.notes);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    typeController.dispose();
    descriptionController.dispose();
    mainMuscleGroupsController.dispose();
    supportMuscleGroupsController.dispose();
    equipmentController.dispose();
    notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseListModel>(
      builder: (context, exerciseListModel, child) {
        return GestureDetector(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(widget.exercise.name),
              actions: [
                IconButton(
                  onPressed: () async {
                    if (nameController.text == "" ||
                        ExerciseType.fromString(typeController.text) == null) {
                      CustomDialog.showAlertDialog(context, "Warning!",
                          "You must compile all mandatory fields.");
                      return;
                    }

                    List<MuscleGroups>? mainMuscleGroups = [];
                    List<MuscleGroups>? supportMuscleGroups = [];
                    List<Equipment>? equipments = [];

                    if (mainMuscleGroupsController.text != "") {
                      for (var muscleGroup
                          in mainMuscleGroupsController.text.split(", ")) {
                        mainMuscleGroups
                            .add(MuscleGroups.fromString(muscleGroup)!);
                      }
                    }

                    if (supportMuscleGroupsController.text != "") {
                      for (var muscleGroup
                          in supportMuscleGroupsController.text.split(", ")) {
                        supportMuscleGroups
                            .add(MuscleGroups.fromString(muscleGroup)!);
                      }
                    }

                    if (equipmentController.text != "") {
                      for (var equipment
                          in equipmentController.text.split(", ")) {
                        equipments.add(Equipment.fromString(equipment)!);
                      }
                    }

                    setState(() {
                      widget.exercise.name = nameController.text;
                      widget.exercise.imagePath1 = "";
                      widget.exercise.imagePath2 = "";
                      widget.exercise.description = descriptionController.text;
                      widget.exercise.type =
                          ExerciseType.fromString(typeController.text)!;
                      widget.exercise.mainMuscleGroups = mainMuscleGroups;
                      widget.exercise.supportMuscleGroups = supportMuscleGroups;
                      widget.exercise.equipment = equipments;
                      widget.exercise.notes = notesController.text;
                    });

                    //Controllo se esiste un esercizio con lo stesso id
                    if (exerciseListModel.exercises
                        .map((item) => item.id)
                        .contains(widget.exercise.id)) {
                      //Se esiste lo aggiorno
                      exerciseListModel.setAt(
                          exerciseListModel.exercises.indexWhere(
                              (exercise) => exercise.id == widget.exercise.id),
                          widget.exercise);
                    } else {
                      //Non esiste, quindo salvo l'esercizio
                      exerciseListModel.add(widget.exercise);
                    }
                  },
                  icon: const Icon(Icons.save_rounded),
                ),
                IconButton(
                  onPressed: () async {
                    //Controllo se esiste un esercizio con lo stesso id
                    if (exerciseListModel.exercises
                        .map((item) => item.id)
                        .contains(widget.exercise.id)) {
                      //Se esiste lo elimino
                      exerciseListModel
                          .removeAt(exerciseListModel.exercises.indexWhere(
                              (exercise) => exercise.id == widget.exercise.id))
                          .then((voidValue) {
                        if (!context.mounted) return;
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete_forever_rounded),
                ),
              ],
            ),
            body: SingleChildScrollView(
              //padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    color: Provider.of<ThemeProvider>(context)
                        .themeData
                        .colorScheme
                        .primaryContainer,
                    margin: const EdgeInsets.only(
                        left: 0, top: 0, right: 0, bottom: 20),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 2,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: Card(
                            semanticContainer: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            clipBehavior: Clip.antiAlias,
                            color: Colors.transparent,
                            child: const Icon(Icons.camera_alt_rounded),
                          ),
                        );
                      },
                    ),
                  ),
                  TextField(
                    maxLines: 3,
                    minLines: 1,
                    clipBehavior: Clip.antiAlias,
                    autofocus: false,
                    controller: nameController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: "-",
                      label: const Text("Name"),
                      labelStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: listTilePadding,
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.info_outline_rounded),
                      prefixIconColor: Provider.of<ThemeProvider>(context)
                          .themeData
                          .colorScheme
                          .tertiaryContainer,
                    ),
                  ),
                  TextField(
                    readOnly: true,
                    maxLines: 3,
                    minLines: 1,
                    clipBehavior: Clip.antiAlias,
                    autofocus: false,
                    controller: typeController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: "-",
                      label: const Text("Type"),
                      labelStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: listTilePadding,
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.category_outlined),
                      prefixIconColor: Provider.of<ThemeProvider>(context)
                          .themeData
                          .colorScheme
                          .tertiaryContainer,
                    ),
                    onTap: () {
                      showModalBottomSheet<void>(
                        //isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return ListView.builder(
                            shrinkWrap: true,
                            clipBehavior: Clip.antiAlias,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: typeList.length,
                            itemBuilder: (context, idx) {
                              final data = typeList[idx];
                              return ListTile(
                                minTileHeight: 55,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                onTap: () {
                                  //Return ExerciseType value
                                  developer.log(data);
                                  setState(() {
                                    typeController.text = data;
                                  });
                                  Navigator.of(context).pop();
                                },
                                leading: const CircleAvatar(
                                  radius: 23,
                                  child: Icon(
                                    size: 30,
                                    Icons.sports_gymnastics_rounded,
                                  ),
                                ),
                                title: Text(
                                  data,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                dense: true,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  TextField(
                    maxLines: 5,
                    minLines: 1,
                    clipBehavior: Clip.antiAlias,
                    autofocus: false,
                    controller: descriptionController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      hintText: "-",
                      label: Text("Description"),
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: listTilePadding,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.notes_rounded),
                    ),
                  ),
                  TextField(
                    readOnly: true,
                    maxLines: 3,
                    minLines: 1,
                    clipBehavior: Clip.antiAlias,
                    autofocus: false,
                    controller: mainMuscleGroupsController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      hintText: "-",
                      label: Text("Main Muscle Groups"),
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: listTilePadding,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.accessibility_rounded),
                    ),
                    onTap: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (BuildContext context,
                                StateSetter updateState) {
                              return Container(
                                margin: const EdgeInsets.only(top: 25),
                                height: 500,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  clipBehavior: Clip.antiAlias,
                                  itemCount: muscleGroups.length,
                                  itemBuilder: (context, idx) {
                                    final data = muscleGroups[idx];
                                    return CheckboxListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      title: Text(
                                        data,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      dense: true,
                                      visualDensity:
                                          const VisualDensity(vertical: -1),
                                      value: selectedMainMuscleGroups
                                          .contains(data),
                                      onChanged: (bool? value) {
                                        if (selectedMainMuscleGroups
                                            .contains(data)) {
                                          updateState(() {
                                            selectedMainMuscleGroups
                                                .remove(data);
                                          });
                                          setState(() {
                                            mainMuscleGroupsController.text =
                                                FormatList.formatStringList(
                                                    selectedMainMuscleGroups
                                                        .cast<String>());
                                          });
                                        } else {
                                          updateState(() {
                                            selectedMainMuscleGroups.add(data);
                                          });
                                          setState(() {
                                            mainMuscleGroupsController.text =
                                                FormatList.formatStringList(
                                                    selectedMainMuscleGroups
                                                        .cast<String>());
                                          });
                                        }
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  TextField(
                    readOnly: true,
                    maxLines: 3,
                    minLines: 1,
                    clipBehavior: Clip.antiAlias,
                    autofocus: false,
                    controller: supportMuscleGroupsController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      hintText: "-",
                      label: Text("Support Muscle Groups"),
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: listTilePadding,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.accessibility_new_rounded),
                    ),
                    onTap: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (BuildContext context,
                                StateSetter updateState) {
                              return Container(
                                margin: const EdgeInsets.only(top: 25),
                                height: 500,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  clipBehavior: Clip.antiAlias,
                                  itemCount: muscleGroups.length,
                                  itemBuilder: (context, idx) {
                                    final data = muscleGroups[idx];
                                    return CheckboxListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      title: Text(
                                        data,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      dense: true,
                                      visualDensity:
                                          const VisualDensity(vertical: -1),
                                      value: selectedSupportMuscleGroups
                                          .contains(data),
                                      onChanged: (bool? value) {
                                        if (selectedSupportMuscleGroups
                                            .contains(data)) {
                                          updateState(() {
                                            selectedSupportMuscleGroups
                                                .remove(data);
                                          });
                                          setState(() {
                                            supportMuscleGroupsController.text =
                                                FormatList.formatStringList(
                                                    selectedSupportMuscleGroups
                                                        .cast<String>());
                                          });
                                        } else {
                                          updateState(() {
                                            selectedSupportMuscleGroups
                                                .add(data);
                                          });
                                          setState(() {
                                            supportMuscleGroupsController.text =
                                                FormatList.formatStringList(
                                                    selectedSupportMuscleGroups
                                                        .cast<String>());
                                          });
                                        }
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  TextField(
                    readOnly: true,
                    maxLines: 3,
                    minLines: 1,
                    clipBehavior: Clip.antiAlias,
                    autofocus: false,
                    controller: equipmentController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      hintText: "-",
                      label: Text("Equipment"),
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: listTilePadding,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.fitness_center_rounded),
                    ),
                    onTap: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (BuildContext context,
                                StateSetter updateState) {
                              return Container(
                                margin: const EdgeInsets.only(top: 25),
                                height: 500,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  clipBehavior: Clip.antiAlias,
                                  itemCount: equipments.length,
                                  itemBuilder: (context, idx) {
                                    final data = equipments[idx];
                                    return CheckboxListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: Text(
                                        data,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      dense: true,
                                      visualDensity:
                                          const VisualDensity(vertical: -1),
                                      value: selectedEquipment.contains(data),
                                      onChanged: (bool? value) {
                                        if (selectedEquipment.contains(data)) {
                                          updateState(() {
                                            selectedEquipment.remove(data);
                                          });
                                          setState(() {
                                            equipmentController.text =
                                                FormatList.formatStringList(
                                                    selectedEquipment
                                                        .cast<String>());
                                          });
                                        } else {
                                          updateState(() {
                                            selectedEquipment.add(data);
                                          });
                                          setState(() {
                                            equipmentController.text =
                                                FormatList.formatStringList(
                                                    selectedEquipment
                                                        .cast<String>());
                                          });
                                        }
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  TextField(
                    maxLines: 5,
                    minLines: 3,
                    clipBehavior: Clip.antiAlias,
                    autofocus: false,
                    controller: notesController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      hintText: "-",
                      label: Text("Notes"),
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: listTilePadding,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.speaker_notes_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            // Remove focus when tapping anywhere on screen, when focus on field
            FocusScope.of(context).requestFocus(FocusNode());
          },
        );
      },
    );
  }
}
