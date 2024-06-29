import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/routine_model.dart';
import 'package:workout_tracker/theme/theme_provider.dart';

import '../models/routine_exercise_model.dart';
import '../services/file_service.dart';

class ModifyRoutine extends StatefulWidget {
  const ModifyRoutine({super.key, required this.routine});

  final RoutineModel routine;

  @override
  State<ModifyRoutine> createState() => _ModifyRoutineState();
}

class _ModifyRoutineState extends State<ModifyRoutine> {
  final List<RoutineModel> _selected = [];
  late bool _selectionEnabled = true;
  late RoutineExerciseModel routineExerciseModel =
      RoutineExerciseModel(null, null, null);

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

    setState(() {
      //Parso la lista con il modello che mi interessa
      var routines = List<RoutineModel>.from(
          data!.map((model) => RoutineModel.fromJson(model)));

      if (routines.map((item) => item.id).contains(widget.routine.id)) {
        //Se esiste lo aggiorno
        routineExerciseModel = routines[routines
                .indexWhere((routine) => routine.id == widget.routine.id)]
            .routineExerciseModel!;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 23,
              backgroundColor: Provider.of<ThemeProvider>(context)
                  .themeData
                  .colorScheme
                  .tertiaryContainer,
              child: const Icon(
                Icons.add_rounded,
              ),
            ),
            title: Title(
              title: "Add Exercises",
              color: Provider.of<ThemeProvider>(context)
                  .themeData
                  .colorScheme
                  .onSecondary,
              child: const Text("Add Exercises"),
            ),
            onTap: () {
              developer.log("cliccato!!!");
            },
          ),
        ],
      ),
    );
  }
}
