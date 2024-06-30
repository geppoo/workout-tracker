import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:workout_tracker/models/exercise_model.dart';
import 'package:workout_tracker/models/screen_model.dart';

import '../services/file_service.dart';
import '../utils/format_list.dart';
import 'modify_exercise.dart';

class Exercises extends StatefulWidget implements ScreenModel {
  Exercises({super.key, required this.context});

  @override
  State<Exercises> createState() => _ExercisesState();

  @override
  final BuildContext context;

  @override
  late final Widget floatingActionButton = FloatingActionButton(
    child: const Icon(Icons.add),
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ModifyExercise(
            exercise: ExerciseModel(
                null, null, null, null, null, null, null, null, null, null),
          ),
        ),
      );
    },
  );

  @override
  set context(BuildContext context) {
    this.context = context;
  }

  @override
  set floatingActionButton(Widget floatingActionButton) {
    this.floatingActionButton = floatingActionButton;
  }
}

class _ExercisesState extends State<Exercises> {
  final List<ExerciseModel> _selected = [];
  late bool _selectionEnabled = true;
  List<ExerciseModel> exercises = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFileData();
    });
  }

  void _initFileData() async {
    Iterable? data = [];

    //Leggo il contenuto del file e lo assegno ad un oggetto Iterable perché é una lista
    await FileService.exercises().readFile().then((fileContent) {
      fileContent ?? (fileContent = "[]");
      data = jsonDecode(fileContent);
    });

    setState(() {
      //Parso la lista con il modello che mi interessa
      exercises = List<ExerciseModel>.from(
          data!.map((model) => ExerciseModel.fromJson(model)));
    });
  }

  void toggleItemSelection(var data) {
    if (_selected.contains(data)) {
      setState(() {
        _selected.remove(data);
      });
    } else {
      setState(() {
        _selected.add(data);
      });
    }

    if (_selected.isNotEmpty) {
      _selectionEnabled = false;
    } else {
      _selectionEnabled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return exercises.isNotEmpty
        ? ListView.builder(
            itemCount: exercises.length, // length of listData
            itemBuilder: (context, idx) {
              final data = exercises[idx]; // shorter variable name
              return ListTile(
                minTileHeight: 70,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                selected: _selected.contains(data),
                onTap: () {
                  // Open modify_exercise screen for selected exercise
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (_) => ModifyExercise(
                        exercise: ExerciseModel(
                          data.id,
                          data.imagePath1,
                          data.imagePath2,
                          data.name,
                          data.type,
                          data.mainMuscleGroups,
                          data.supportMuscleGroups,
                          data.description,
                          data.equipment,
                          data.notes,
                        ),
                      ),
                    ),
                  )
                      .then((value) {
                    _initFileData();
                  });
                },
                enabled: _selectionEnabled,
                leading: _selected.contains(data)
                    ? CircleAvatar(
                        radius: 24,
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.done_rounded),
                          onPressed: () {
                            toggleItemSelection(data);
                          },
                        ),
                      )
                    : CircleAvatar(
                        radius: 24,
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.fitness_center_rounded),
                          onPressed: () {
                            toggleItemSelection(data);
                          },
                        ),
                      ),
                title: Text(
                  data.name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                dense: true,
                visualDensity: const VisualDensity(vertical: -1),
                subtitle: Text(
                  data.mainMuscleGroups == null
                      ? "-"
                      : FormatList.formatMuscleGroupList(data.mainMuscleGroups),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          )
        : const Center(
            child: Text("No exercise found"),
          );
  }
}
