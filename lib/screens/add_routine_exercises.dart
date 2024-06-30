import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:workout_tracker/models/routine_exercise_model.dart';
import 'package:workout_tracker/models/routine_model.dart';

import '../models/exercise_model.dart';
import '../services/file_service.dart';
import '../utils/format_list.dart';

class AddRoutineExercises extends StatefulWidget {
  const AddRoutineExercises({super.key, required this.routine});

  final RoutineModel routine;

  @override
  State<AddRoutineExercises> createState() => _AddRoutineExercisesState();
}

class _AddRoutineExercisesState extends State<AddRoutineExercises> {
  final List<ExerciseModel> _selected = [];
  late bool _selectionEnabled = true;
  List<ExerciseModel> exercises = [];
  List<ExerciseModel> routineExercises = [];
  List<RoutineModel> routines = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFileData();
    });
  }

  void _initFileData() async {
    Iterable? exerciseData = [];
    Iterable? routineData = [];

    await FileService.exercises().readFile().then((fileContent) {
      fileContent ?? (fileContent = "[]");
      exerciseData = jsonDecode(fileContent);
    });

    await FileService.routines().readFile().then((fileContent) {
      fileContent ?? (fileContent = "[]");
      routineData = jsonDecode(fileContent);
    });

    setState(() {
      exercises = List<ExerciseModel>.from(
          exerciseData!.map((model) => ExerciseModel.fromJson(model)));

      routines = List<RoutineModel>.from(
          routineData!.map((model) => RoutineModel.fromJson(model)));

      //Recupero tutti gli esercizi legati alla routine
      widget.routine.routineExercises?.forEach((routineExercise) {
        routineExercises.add(exercises[exercises.indexWhere(
            (exercise) => exercise.id == routineExercise.exerciseId)]);
      });

      var set1 = exercises.toSet();
      var set2 = routineExercises.toSet();
      exercises = List.from(set1.difference(set2));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Exercises"),
        actions: [
          Offstage(
            offstage: _selected.isEmpty,
            child: IconButton(
              onPressed: () {
                //merge delle liste di esercizi in modo da avere la nuova lista completa
                _selected.addAll(routineExercises);

                widget.routine.routineExercises ??= {};

                //popolo le serie della lista e le salvo con valori di default
                for (var exercise in _selected) {
                  widget.routine.routineExercises?.add(
                    RoutineExerciseModel(
                      exercise.id,
                      [
                        ExerciseSerieModel(0, 10, 120),
                        ExerciseSerieModel(0, 10, 120),
                        ExerciseSerieModel(0, 10, 120),
                      ],
                    ),
                  );
                }

                //Aggiorno la routine nel file
                routines[routines.indexWhere(
                        (routine) => routine.id == widget.routine.id)] =
                    widget.routine;

                developer.log(jsonEncode(routines));

                FileService.routines().writeFile(jsonEncode(routines));

                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_rounded),
            ),
          )
        ],
      ),
      body: exercises.isNotEmpty
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
                    // add selected exercise
                    toggleItemSelection(data);
                  },
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
                  subtitle: Offstage(
                    offstage: data.mainMuscleGroups != null,
                    child: Text(
                      data.mainMuscleGroups == null
                          ? "-"
                          : FormatList.formatMuscleGroupList(
                              data.mainMuscleGroups),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text("No exercise found"),
            ),
    );
  }
}
