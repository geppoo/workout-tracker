import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/routine_list_model.dart';
import 'package:workout_tracker/models/routine_model.dart';
import 'package:workout_tracker/screens/edit_routine.dart';
import 'package:workout_tracker/widgets/routines_floating_action_button.dart';

import '../theme/theme_provider.dart';
import '../widgets/bottom_navbar.dart';

class Routines extends StatefulWidget {
  const Routines({super.key});

  @override
  State<Routines> createState() => _RoutinesState();
}

class _RoutinesState extends State<Routines> {
  final List<RoutineModel> _selected = [];
  late bool _selectionEnabled = true;

  @override
  void initState() {
    super.initState();
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
      body: Consumer<RoutineListModel>(
        builder: (context, routineListModel, child) {
          return routineListModel.routines.isNotEmpty
              ? ListView.builder(
                  itemCount:
                      routineListModel.routines.length, // length of listData
                  itemBuilder: (context, idx) {
                    final data =
                        routineListModel.routines[idx]; // shorter variable name
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
                                builder: (_) => EditRoutine(
                                  routine: RoutineModel(
                                    data.id,
                                    data.name,
                                    data.hexIconColor,
                                    data.routineExercises,
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
                              radius: 24,
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
                    );
                  },
                )
              : const Center(
                  child: Text("No routine found"),
                );
        },
      ),
      floatingActionButton: const RoutinesFloatingActionButton(),
    );
  }
}
