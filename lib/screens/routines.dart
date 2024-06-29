import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:workout_tracker/models/routine_model.dart';
import 'package:workout_tracker/models/screen_model.dart';
import 'package:workout_tracker/screens/modify_routine.dart';

import '../services/file_service.dart';

class Routines extends StatefulWidget implements ScreenModel {
  Routines({super.key, required this.context});

  @override
  State<Routines> createState() => _RoutinesState();

  @override
  final BuildContext context;

  final _listTilePadding =
      const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10);

  final _titleTextController = TextEditingController();

  @override
  late final Widget floatingActionButton = FloatingActionButton(
    child: const Icon(Icons.add),
    onPressed: () {
      showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            height: 500,
            child: GestureDetector(
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  actions: [
                    IconButton(
                      onPressed: () async {
                        //TODO aggiungere logica per salvare routine
                        developer.log(_titleTextController.text);

                        RoutineModel routine = RoutineModel(
                          UniqueKey().hashCode,
                          _titleTextController.text,
                          null,
                          null,
                        );

                        Iterable? data = [];

                        //Per pulire vecchio file
                        //FileService.routines().deleteFile();

                        //Leggo il contenuto del file e lo assegno ad un oggetto Iterable perché é una lista
                        await FileService.routines()
                            .readFile()
                            .then((fileContent) {
                          fileContent ?? (fileContent = "[]");
                          data = jsonDecode(fileContent);
                        });

                        //Parso la lista con il modello che mi interessa
                        List<RoutineModel> routines = List<RoutineModel>.from(
                            data!.map((model) => RoutineModel.fromJson(model)));

                        //Creo una nuova routine
                        routines.add(routine);
                        FileService.routines().writeFile(jsonEncode(routines));
                        developer.log("Routine salvata!!!");
                      },
                      icon: const Icon(Icons.check_rounded),
                    )
                  ],
                ),
                body: TextField(
                  maxLines: 2,
                  minLines: 1,
                  clipBehavior: Clip.antiAlias,
                  autofocus: false,
                  controller: _titleTextController,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: "ie. core workout",
                    label: const Text("Routine Name"),
                    labelStyle: const TextStyle(
                      fontSize: 18,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: _listTilePadding,
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.info_outline_rounded),
                  ),
                ),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          );
        },
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
    Iterable? data = [];

    //Leggo il contenuto del file e lo assegno ad un oggetto Iterable perché é una lista
    await FileService.routines().readFile().then((fileContent) {
      fileContent ?? (fileContent = "[]");
      data = jsonDecode(fileContent);
    });

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
                          data.exercises,
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
