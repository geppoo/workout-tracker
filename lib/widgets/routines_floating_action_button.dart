import 'dart:developer' as developer;

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/routine_list_model.dart';
import '../models/routine_model.dart';

class RoutinesFloatingActionButton extends StatefulWidget {
  const RoutinesFloatingActionButton({super.key});

  @override
  State<RoutinesFloatingActionButton> createState() =>
      _RoutinesFloatingActionButtonState();
}

class _RoutinesFloatingActionButtonState
    extends State<RoutinesFloatingActionButton> {
  final _listTilePadding =
      const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10);
  Color _selectedRoutineColor = Colors.orange;
  final _titleTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _titleTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutineListModel>(
      builder: (context, routineListModel, child) {
        return FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              enableDrag: true,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter updateState) {
                    return Wrap(
                      children: <Widget>[
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.70,
                          child: GestureDetector(
                            child: Scaffold(
                              resizeToAvoidBottomInset: false,
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
                                      RoutineModel routine = RoutineModel(
                                        UniqueKey().hashCode,
                                        _titleTextController.text,
                                        _selectedRoutineColor.value,
                                        null,
                                      );

                                      routineListModel
                                          .add(routine)
                                          .then((voidValue) {
                                        if (!context.mounted) return;
                                        Navigator.pop(context);
                                      });
                                    },
                                    icon: const Icon(Icons.check_rounded),
                                  )
                                ],
                              ),
                              body: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
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
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      contentPadding: _listTilePadding,
                                      border: InputBorder.none,
                                      prefixIcon: const Icon(
                                          Icons.info_outline_rounded),
                                    ),
                                  ),
                                  ColorPicker(
                                    onColorChanged: (Color value) {
                                      setState(() {
                                        _selectedRoutineColor = value;
                                      });
                                      updateState(() {
                                        _selectedRoutineColor = value;
                                      });
                                      developer.log(value.toString());
                                    },
                                    selectedPickerTypeColor:
                                        _selectedRoutineColor,
                                    title: const Text("Routine Color"),
                                    pickersEnabled: const <ColorPickerType,
                                        bool>{
                                      ColorPickerType.wheel: true,
                                      ColorPickerType.primary: true,
                                      ColorPickerType.accent: true,
                                    },
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
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
        );
      },
    );
  }
}
