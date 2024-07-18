import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/models/body_list_model.dart';

import '../models/body_model.dart';
import '../theme/theme_provider.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController weightController = TextEditingController();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  TextStyle cardTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Body",
        ),
      ),
      body: Consumer<BodyListModel>(
        builder: (context, bodyListModel, child) {
          BodyModel lastBodyTrack = bodyListModel.bodyTrack.isNotEmpty
              ? bodyListModel.bodyTrack.last
              : BodyModel(1, DateTime.now(), 0, 0, 0, 0, 0, 0);
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Card.outlined(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    elevation: 2,
                    color: Provider.of<ThemeProvider>(context)
                        .themeData
                        .colorScheme
                        .secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Last Update (${bodyListModel.bodyTrack.isEmpty ? "Never" : formatter.format(lastBodyTrack.day)})",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        "Weight ${lastBodyTrack.weight.toString().replaceAll(regex, "")} (kg)",
                                        style: cardTextStyle,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        "Height ${lastBodyTrack.height.toString().replaceAll(regex, "")} (cm)",
                                        style: cardTextStyle,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        "Water ${lastBodyTrack.water.toString().replaceAll(regex, "")}%",
                                        style: cardTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        "Fat Mass ${lastBodyTrack.fatMass.toString().replaceAll(regex, "")}%",
                                        style: cardTextStyle,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        "Lean Mass ${lastBodyTrack.leanMass.toString().replaceAll(regex, "")}%",
                                        style: cardTextStyle,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        "Muscle Mass ${lastBodyTrack.muscleMass.toString().replaceAll(regex, "")}%",
                                        style: cardTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
                              label: Text("Weight (kg)"),
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
                              label: Text("Height (cm)"),
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
                              label: Text("Muscle Mass %"),
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.today_rounded),
        onPressed: () {},
      ),
    );
  }
}
