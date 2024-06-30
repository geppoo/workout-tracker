import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/routine_model.dart';
import 'package:workout_tracker/screens/add_routine_exercises.dart';

import '../models/exercise_model.dart';
import '../models/routine_exercise_model.dart';
import '../services/file_service.dart';
import '../theme/theme_provider.dart';

class ModifyRoutine extends StatefulWidget {
  const ModifyRoutine({super.key, required this.routine});

  final RoutineModel routine;

  @override
  State<ModifyRoutine> createState() => _ModifyRoutineState();
}

class _ModifyRoutineState extends State<ModifyRoutine> {
  final List<ExerciseModel> _selected = [];
  late bool _selectionEnabled = true;
  List<ExerciseModel> routineExercises = [];
  List<ExerciseModel> exercises = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFileData();
    });
  }

  void _initFileData() async {
    //FileService.routines().deleteFile();
    exercises = [];
    routineExercises = [];

    Iterable? data = [];

    //Leggo il contenuto del file e lo assegno ad un oggetto Iterable perché é una lista
    await FileService.exercises().readFile().then((fileContent) {
      fileContent ?? (fileContent = "[]");
      data = jsonDecode(fileContent);
    });

    exercises = List<ExerciseModel>.from(
        data!.map((model) => ExerciseModel.fromJson(model)));

    setState(() {
      //Recupero tutti gli esercizi legati alla routine
      widget.routine.routineExercises?.forEach((routineExercise) {
        routineExercises.add(exercises[exercises.indexWhere(
            (exercise) => exercise.id == routineExercise.exerciseId)]);
      });

      developer.log(widget.routine.toString());
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
        title: Text(
            widget.routine.name != null ? widget.routine.name! : "loading..."),
      ),
      body: routineExercises.isNotEmpty
          ? ListView.builder(
              itemCount: routineExercises.length, // length of listData
              itemBuilder: (context, idx) {
                final data = routineExercises[idx]; // shorter variable name
                return ListTile(
                  minTileHeight: 70,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  selected: _selected.contains(data),
                  onTap: () {
                    // Open modify_exercise_serie modal for selected exercise
                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                      context: context,
                      enableDrag: true,
                      builder: (BuildContext context) {
                        //cerco il RoutineExerciseModel della mia routine tramite esercizio
                        RoutineExerciseModel routineExercise = widget
                            .routine.routineExercises!
                            .firstWhere((value) => value.exerciseId == data.id);

                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter updateState) {
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
                                      MediaQuery.of(context).size.height * 0.70,
                                  child: GestureDetector(
                                    child: Scaffold(
                                      resizeToAvoidBottomInset: false,
                                      appBar: AppBar(
                                        title: Text(data.name!),
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
                                              //TODO implementare logica per salvare RoutineExerciseModel
                                            },
                                            icon:
                                                const Icon(Icons.check_rounded),
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
                                                  alignment: Alignment.center,
                                                  padding:
                                                      const EdgeInsets.all(20),
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
                                                        "${routineExercise.exerciseSeries?.length}",
                                                        style: const TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 15),
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
                                                            //TODO implementare modifica numero ripetizioni
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
                                                            //TODO implementare modifica numero ripetizioni
                                                          },
                                                          icon: const Icon(
                                                            Icons.add_rounded,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
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
                  leading: _selected.contains(data)
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
                    data.name ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  dense: true,
                  /*subtitle: const Text("test",
            overflow: TextOverflow.ellipsis,
          ),*/
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
              .then((value) {
            _initFileData();
          });
        },
      ),
    );
  }
}
