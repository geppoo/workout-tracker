import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/exercise_list_model.dart';
import 'package:workout_tracker/models/routine_exercise_model.dart';
import 'package:workout_tracker/models/routine_model.dart';

import '../models/exercise_model.dart';
import '../models/routine_list_model.dart';
import '../utils/format_list.dart';

class AddRoutineExercises extends StatefulWidget {
  const AddRoutineExercises({super.key, required this.routine});

  final RoutineModel routine;

  @override
  State<AddRoutineExercises> createState() => _AddRoutineExercisesState();
}

class _AddRoutineExercisesState extends State<AddRoutineExercises> {
  final List<ExerciseModel> _selected = [];

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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RoutineListModel, ExerciseListModel>(
      builder: (context, routineListModel, exerciseListModel, child) {
        Iterable<ExerciseModel> list = [];
        if (widget.routine.routineExercises != null) {
          list = exerciseListModel.exercises.where((exercise) => !widget
              .routine.routineExercises!
              .map((exRoutineModel) => exRoutineModel.exercise)
              .toList()
              .contains(exercise));
        } else {
          list = exerciseListModel.exercises;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Select Exercises"),
            actions: [
              Offstage(
                offstage: _selected.isEmpty,
                child: IconButton(
                  onPressed: () {
                    widget.routine.routineExercises ??= {};
                    //popolo le serie della lista e le salvo con valori di default
                    for (var exercise in _selected) {
                      widget.routine.routineExercises?.add(
                        RoutineExerciseModel(
                          exercise,
                          [
                            ExerciseSerieModel(0, 10, 120),
                            ExerciseSerieModel(0, 10, 120),
                            ExerciseSerieModel(0, 10, 120),
                          ],
                        ),
                      );
                    }

                    //Aggiorno la routine nel file
                    routineListModel
                        .setAt(
                            routineListModel.routines.indexWhere(
                                (routine) => routine.id == widget.routine.id),
                            widget.routine)
                        .then((voidVal) => Navigator.pop(context));
                  },
                  icon: const Icon(Icons.check_rounded),
                ),
              )
            ],
          ),
          body: list.isNotEmpty
              ? ListView.builder(
                  itemCount: list.length, // length of listData
                  itemBuilder: (context, idx) {
                    final data = list.elementAt(idx); // shorter variable name
                    return ListTile(
                      minTileHeight: 70,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
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
      },
    );
  }
}
