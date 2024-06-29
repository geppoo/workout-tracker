import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/routine_model.dart';
import 'package:workout_tracker/models/screen_model.dart';
import 'package:workout_tracker/screens/modify_routine.dart';
import 'package:workout_tracker/widgets/routines_floating_action_button.dart';

import '../services/file_service.dart';
import '../theme/theme_provider.dart';

class Routines extends StatefulWidget implements ScreenModel {
  const Routines({super.key, required this.context});

  @override
  State<Routines> createState() => _RoutinesState();

  @override
  final BuildContext context;

  @override
  final Widget floatingActionButton = const RoutinesFloatingActionButton();

  @override
  set context(BuildContext context) {
    this.context = context;
  }

  @override
  set floatingActionButton(Widget floatingActionButton) {
    this.floatingActionButton = floatingActionButton;
  }
}

class _RoutinesState extends State<Routines> {
  final List<RoutineModel> _selected = [];
  late bool _selectionEnabled = true;
  List<RoutineModel> routines = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFileData();
    });
  }

  void _initFileData() async {
    //FileService.routines().deleteFile();

    Iterable? data = [];

    //Leggo il contenuto del file e lo assegno ad un oggetto Iterable perché é una lista
    await FileService.routines().readFile().then((fileContent) {
      fileContent ?? (fileContent = "[]");
      data = jsonDecode(fileContent);
    });

    developer.log(data.toString());

    setState(() {
      //Parso la lista con il modello che mi interessa
      routines = List<RoutineModel>.from(
          data!.map((model) => RoutineModel.fromJson(model)));
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
    return routines.isNotEmpty
        ? ListView.builder(
            itemCount: routines.length, // length of listData
            itemBuilder: (context, idx) {
              final data = routines[idx]; // shorter variable name
              return ListTile(
                minTileHeight: 70,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                selected: _selected.contains(data),
                selectedTileColor: Colors.transparent,
                selectedColor: Colors.transparent,
                onTap: () {
                  // Open modify_exercise screen for selected exercise
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (_) => ModifyRoutine(
                        routine: RoutineModel(
                          data.id,
                          data.name,
                          data.hexIconColor,
                          data.routineExerciseModel,
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
                        radius: 23,
                        backgroundColor: data.hexIconColor != null
                            ? Color(data.hexIconColor!)
                            : Provider.of<ThemeProvider>(context)
                                .themeData
                                .colorScheme
                                .secondaryContainer,
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
                        backgroundColor: data.hexIconColor != null
                            ? Color(data.hexIconColor!)
                            : Provider.of<ThemeProvider>(context)
                                .themeData
                                .colorScheme
                                .primaryContainer,
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
                visualDensity: const VisualDensity(vertical: -1),
                /*subtitle: const Text("test",
            overflow: TextOverflow.ellipsis,
          ),*/
              );
            },
          )
        : const Center(
            child: Text("No routine found"),
          );
  }
}
