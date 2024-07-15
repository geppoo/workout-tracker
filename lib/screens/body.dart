import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:workout_tracker/models/screen_model.dart';

class Body extends StatefulWidget implements ScreenModel {
  Body({super.key, required this.context});

  @override
  State<Body> createState() => _BodyState();

  @override
  final BuildContext context;

  @override
  late final Widget floatingActionButton = Visibility(
    visible: false,
    child: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {},
    ),
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

class _BodyState extends State<Body> {
  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        developer.log(value);
                      },
                      onTapOutside: (event) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      decoration: const InputDecoration(
                        label: Text("Weight"),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        developer.log(value);
                      },
                      onTapOutside: (event) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      decoration: const InputDecoration(
                        label: Text("Height"),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        developer.log(value);
                      },
                      onTapOutside: (event) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      decoration: const InputDecoration(
                        label: Text("Fat Mass %"),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        developer.log(value);
                      },
                      onTapOutside: (event) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      decoration: const InputDecoration(
                        label: Text("Lean Mass %"),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        developer.log(value);
                      },
                      onTapOutside: (event) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      decoration: const InputDecoration(
                        label: Text("Water %"),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
