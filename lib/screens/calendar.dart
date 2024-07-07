import 'package:flutter/material.dart';
import 'package:workout_tracker/models/screen_model.dart';

class Calendar extends StatefulWidget implements ScreenModel {
  Calendar({super.key, required this.context});

  @override
  State<Calendar> createState() => _CalendarState();

  @override
  final BuildContext context;

  @override
  late final Widget floatingActionButton = Offstage(
    offstage: true,
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
      title: const Text("Calendar"),
      content: const Text("Calendar yay!"),
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

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Calendar",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
