import 'package:flutter/material.dart';

import '../widgets/bottom_navbar.dart';

class Other extends StatefulWidget {
  const Other({super.key});

  @override
  State<Other> createState() => _OtherState();

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
      title: const Text("Other"),
      content: const Text("Other yay!"),
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

class _OtherState extends State<Other> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Other",
        ),
      ),
    );
  }
}
