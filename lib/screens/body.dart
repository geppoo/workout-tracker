import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      onPressed: () {
        showAlertDialog(context);
      },
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

  static void showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Body"),
      content: const Text("Body yay!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Body",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
