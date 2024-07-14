import 'dart:developer' as developer;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/routine_model.dart';
import 'package:workout_tracker/screens/add_routine_exercises.dart';

import '../models/exercise_list_model.dart';
import '../models/exercise_model.dart';
import '../models/routine_exercise_model.dart';
import '../models/routine_list_model.dart';
import '../theme/theme_provider.dart';

class EditRoutine extends StatefulWidget {
  const EditRoutine({super.key, required this.routine});

  final RoutineModel routine;

  @override
  State<EditRoutine> createState() => _EditRoutineState();
}

class _EditRoutineState extends State<EditRoutine>
    with SingleTickerProviderStateMixin {
  late List<ExerciseModel> _selected = [];
  late bool _selectionEnabled = true;
  late AnimationController _controller;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
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
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RoutineListModel, ExerciseListModel>(
      builder: (context, routineListModel, exerciseListModel, child) {
        /*List<ExerciseModel> routineExercises = [];
        if (widget.routine.routineExercises != null) {
          routineExercises = exerciseListModel.exercises
              .where((exercise) => widget.routine.routineExercises!
                  .map((exRoutineModel) => exRoutineModel.exercise)
                  .toList()
                  .contains(exercise))
              .toList();
        }*/

        List<RoutineExerciseModel> routineExercises = [];
        if (widget.routine.routineExercises != null) {
          routineExercises = widget.routine.routineExercises!.toList();
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(widget.routine.name),
            actions: [
              Offstage(
                offstage: _selected.isEmpty,
                child: IconButton(
                  icon: const Icon(Icons.delete_forever_outlined),
                  onPressed: () {
                    for (var selectedExercise in _selected) {
                      widget.routine.routineExercises?.removeWhere(
                          (exercise) => exercise.exercise == selectedExercise);
                    }
                    routineListModel.setAt(
                        routineListModel.routines.indexWhere(
                            (routine) => routine.id == widget.routine.id),
                        widget.routine);

                    setState(() {
                      _selected = [];
                      _selectionEnabled = true;
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.playlist_remove_rounded),
                onPressed: () {
                  routineListModel.removeAt(
                    routineListModel.routines.indexWhere(
                        (routine) => routine.id == widget.routine.id),
                  );

                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: routineExercises.isNotEmpty
              ? ListView.builder(
                  itemCount: routineExercises.length,
                  itemBuilder: (context, idx) {
                    final data = routineExercises[idx];
                    //Init subtitle
                    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
                    String weightSubtitle = "Peso";
                    String repsSubtitle = "Rip.";
                    for (final serie in data.exerciseSeries) {
                      weightSubtitle =
                          "$weightSubtitle ${serie.weight.toString().replaceAll(regex, "")},";
                      repsSubtitle =
                          "$repsSubtitle ${serie.repetitions.toString()},";
                    }
                    weightSubtitle =
                        weightSubtitle.substring(0, weightSubtitle.length - 1);
                    repsSubtitle =
                        repsSubtitle.substring(0, repsSubtitle.length - 1);
                    return ListTile(
                      minTileHeight: 70,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      selected: _selected.contains(data.exercise),
                      onTap: () {
                        // Open modify_exercise_serie modal for selected exercise
                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          enableDrag: true,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter updateState) {
                                return Wrap(
                                  children: <Widget>[
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.70,
                                      child: GestureDetector(
                                        child: Scaffold(
                                          resizeToAvoidBottomInset: true,
                                          appBar: AppBar(
                                            title: Text(data.exercise.name),
                                            leading: IconButton(
                                              icon: const Icon(
                                                  Icons.arrow_back_rounded),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            actions: [
                                              IconButton(
                                                onPressed: () async {
                                                  routineListModel
                                                      .setAt(
                                                          routineListModel
                                                              .routines
                                                              .indexWhere(
                                                                  (routine) =>
                                                                      routine
                                                                          .id ==
                                                                      widget
                                                                          .routine
                                                                          .id),
                                                          widget.routine)
                                                      .then((voidValue) {
                                                    Navigator.pop(context);
                                                  });

                                                  var snackBar = SnackBar(
                                                    content: Text(
                                                      'Information saved!',
                                                      style: TextStyle(
                                                        color: Provider.of<
                                                                    ThemeProvider>(
                                                                context,
                                                                listen: false)
                                                            .themeData
                                                            .colorScheme
                                                            .onSecondaryContainer,
                                                      ),
                                                    ),
                                                    showCloseIcon: true,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor: Provider
                                                            .of<ThemeProvider>(
                                                                context,
                                                                listen: false)
                                                        .themeData
                                                        .colorScheme
                                                        .secondaryContainer,
                                                    closeIconColor: Provider.of<
                                                                ThemeProvider>(
                                                            context,
                                                            listen: false)
                                                        .themeData
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                },
                                                icon: const Icon(
                                                    Icons.check_rounded),
                                              )
                                            ],
                                          ),
                                          body: Column(
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      color: Provider.of<
                                                                  ThemeProvider>(
                                                              context)
                                                          .themeData
                                                          .colorScheme
                                                          .primaryContainer,
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            "Series",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                          ),
                                                          Text(
                                                            "${data.exerciseSeries.length}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 25),
                                                          ),
                                                          CircleAvatar(
                                                            backgroundColor: Provider
                                                                    .of<ThemeProvider>(
                                                                        context)
                                                                .themeData
                                                                .colorScheme
                                                                .secondaryContainer,
                                                            child: IconButton(
                                                              onPressed: () {
                                                                if (data.exerciseSeries
                                                                        .length >
                                                                    1) {
                                                                  updateState(
                                                                      () {
                                                                    data.exerciseSeries
                                                                        .removeLast();
                                                                  });
                                                                }
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .remove_rounded,
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                          ),
                                                          CircleAvatar(
                                                            backgroundColor: Provider
                                                                    .of<ThemeProvider>(
                                                                        context)
                                                                .themeData
                                                                .colorScheme
                                                                .secondaryContainer,
                                                            child: IconButton(
                                                              onPressed: () {
                                                                var exerciseCopy =
                                                                    data.exerciseSeries
                                                                        .last;

                                                                updateState(() {
                                                                  data.exerciseSeries
                                                                      .add(
                                                                    ExerciseSerieModel(
                                                                      exerciseCopy
                                                                          .weight,
                                                                      exerciseCopy
                                                                          .repetitions,
                                                                      exerciseCopy
                                                                          .restSeconds,
                                                                    ),
                                                                  );
                                                                });
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .add_rounded,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: 20,
                                                ),
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount: data
                                                      .exerciseSeries.length,
                                                  itemBuilder: (context, idx) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        bottom: 15,
                                                      ),
                                                      child: IntrinsicHeight(
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "$idx°",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                            ),
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                right: 20,
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: SizedBox(
                                                                width: 50,
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      TextEditingController(
                                                                    text:
                                                                        "${data.exerciseSeries.elementAt(idx).weight}",
                                                                  ),
                                                                  onSubmitted:
                                                                      (value) {
                                                                    updateState(
                                                                        () {
                                                                      data.exerciseSeries
                                                                          .elementAt(
                                                                              idx)
                                                                          .weight = double.parse(value);
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                              child: Text(
                                                                "kg",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                right: 15,
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: SizedBox(
                                                                width: 50,
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      TextEditingController(
                                                                    text:
                                                                        "${data.exerciseSeries.elementAt(idx).restSeconds}",
                                                                  ),
                                                                  onSubmitted:
                                                                      (value) {
                                                                    updateState(
                                                                        () {
                                                                      data.exerciseSeries
                                                                          .elementAt(
                                                                              idx)
                                                                          .restSeconds = int.parse(value);
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                              child: Text(
                                                                "s",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                right: 25,
                                                              ),
                                                            ),
                                                            ConstrainedBox(
                                                              constraints:
                                                                  const BoxConstraints(
                                                                minWidth: 35,
                                                              ),
                                                              child: Text(
                                                                "${data.exerciseSeries.elementAt(idx).repetitions}x",
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ),
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                right: 20,
                                                              ),
                                                            ),
                                                            CircleAvatar(
                                                              backgroundColor: Provider
                                                                      .of<ThemeProvider>(
                                                                          context)
                                                                  .themeData
                                                                  .colorScheme
                                                                  .secondaryContainer,
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  var repetitions = data
                                                                      .exerciseSeries
                                                                      .elementAt(
                                                                          idx)
                                                                      .repetitions;

                                                                  updateState(
                                                                      () {
                                                                    data.exerciseSeries
                                                                            .elementAt(
                                                                                idx)
                                                                            .repetitions =
                                                                        (repetitions! -
                                                                            1);
                                                                  });
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .remove_rounded,
                                                                ),
                                                              ),
                                                            ),
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10),
                                                            ),
                                                            CircleAvatar(
                                                              backgroundColor: Provider
                                                                      .of<ThemeProvider>(
                                                                          context)
                                                                  .themeData
                                                                  .colorScheme
                                                                  .secondaryContainer,
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  var repetitions = data
                                                                      .exerciseSeries
                                                                      .elementAt(
                                                                          idx)
                                                                      .repetitions;

                                                                  updateState(
                                                                      () {
                                                                    data.exerciseSeries
                                                                            .elementAt(
                                                                                idx)
                                                                            .repetitions =
                                                                        (repetitions! +
                                                                            1);
                                                                  });
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .add_rounded,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      enabled: _selectionEnabled,
                      leading: _selected.contains(data.exercise)
                          ? CircleAvatar(
                              radius: 23,
                              child: IconButton(
                                iconSize: 30,
                                icon: const Icon(Icons.done_rounded),
                                onPressed: () {
                                  toggleItemSelection(data);
                                },
                              ),
                            )
                          : CircleAvatar(
                              radius: 23,
                              child: IconButton(
                                iconSize: 30,
                                icon: const Icon(Icons.assignment_outlined),
                                onPressed: () {
                                  toggleItemSelection(data);
                                },
                              ),
                            ),
                      title: Text(
                        data.exercise.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      dense: true,
                      subtitle: Text(
                        "Serie ${data.exerciseSeries.length} $weightSubtitle $repsSubtitle",
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("Routine has no exercises yet"),
                ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (_) => AddRoutineExercises(
                        routine: widget.routine,
                      ),
                    ),
                  )
                  .then((value) {});
            },
          ),
        );
      },
    );
  }
}
