import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/constants/exercise_type.dart';
import 'package:workout_tracker/models/exercise_model.dart';

import '../models/exercise_list_model.dart';
import '../theme/theme_provider.dart';
import '../utils/format_list.dart';
import 'edit_exercise.dart';

class Exercises extends StatefulWidget {
  const Exercises({super.key});

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  final List<ExerciseModel> _selected = [];
  late bool _selectionEnabled = true;
  bool _searchBoolean = false;
  List<int> _searchIndexList = []; //add

  Widget _searchTextField(UnmodifiableListView<ExerciseModel> list) {
    return TextField(
      autofocus: true,
      style: const TextStyle(
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: const TextStyle(
          fontSize: 20,
        ),
        filled: true,
        fillColor: Provider.of<ThemeProvider>(context)
            .themeData
            .colorScheme
            .onPrimaryFixedVariant,
      ),
      onChanged: (String s) {
        //add
        setState(() {
          _searchIndexList = [];
          for (int i = 0; i < list.length; i++) {
            if (list[i].name.toUpperCase().contains(s.toUpperCase())) {
              _searchIndexList.add(i);
            }
          }
        });
      },
    );
  }

  Widget _searchListView(UnmodifiableListView<ExerciseModel> list) {
    return ListView.builder(
      itemCount: _searchIndexList.length,
      itemBuilder: (context, idx) {
        idx = _searchIndexList[idx];
        final data = list[idx];
        return ListTile(
          minTileHeight: 70,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          selected: _selected.contains(data),
          onTap: () {
            // Open modify_exercise screen for selected exercise
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (_) => EditExercise(
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
                .then((value) {});
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
            data.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          dense: true,
          subtitle: Text(
            data.mainMuscleGroups == null || data.mainMuscleGroups!.isEmpty
                ? "-"
                : FormatList.formatMuscleGroupList(data.mainMuscleGroups),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
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
    return Consumer<ExerciseListModel>(
      builder: (context, exerciseListModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: !_searchBoolean
                ? const Text("Exercises")
                : _searchTextField(exerciseListModel.exercises),
            actions: !_searchBoolean
                ? [
                    IconButton(
                        icon: const Icon(Icons.search_rounded),
                        onPressed: () {
                          setState(() {
                            _searchBoolean = true;
                            _searchIndexList = [];
                          });
                        })
                  ]
                : [
                    IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          setState(() {
                            _searchBoolean = false;
                          });
                        })
                  ],
          ),
          body: !_searchBoolean
              ? exerciseListModel.exercises.isNotEmpty
                  ? ListView.builder(
                      itemCount: exerciseListModel.exercises.length,
                      itemBuilder: (context, idx) {
                        final data = exerciseListModel.exercises[idx];
                        return ListTile(
                          minTileHeight: 70,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          selected: _selected.contains(data),
                          onTap: () {
                            // Open modify_exercise screen for selected exercise
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => EditExercise(
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
                                .then((value) {});
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
                                    icon: const Icon(
                                        Icons.fitness_center_rounded),
                                    onPressed: () {
                                      toggleItemSelection(data);
                                    },
                                  ),
                                ),
                          title: Text(
                            data.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          dense: true,
                          subtitle: Text(
                            data.mainMuscleGroups == null ||
                                    data.mainMuscleGroups!.isEmpty
                                ? "-"
                                : FormatList.formatMuscleGroupList(
                                    data.mainMuscleGroups),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("No exercise found"),
                    )
              : _searchListView(exerciseListModel.exercises),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditExercise(
                    exercise: ExerciseModel(
                      UniqueKey().hashCode,
                      null,
                      null,
                      "Name",
                      ExerciseType.conPesi,
                      null,
                      null,
                      null,
                      null,
                      null,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
