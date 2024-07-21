import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_tracker/models/setting_model.dart';

import '../models/setting_list_model.dart';

class Other extends StatefulWidget {
  const Other({super.key});

  @override
  State<Other> createState() => _OtherState();
}

class _OtherState extends State<Other> {
  bool _darkTheme = false;
  final Uri _url = Uri.parse('https://github.com/geppoo/workout-tracker');

  @override
  void initState() {
    super.initState();
    /*_darkTheme = Provider.of<ThemeProvider>(context, listen: false).themeData ==
        CustomThemes().darkMode;*/
    _darkTheme = Provider.of<SettingListModel>(context, listen: false)
            .settings
            .firstWhere((setting) => setting.name == "theme")
            .value ==
        "darkMode";
    developer.log(Provider.of<SettingListModel>(context, listen: false)
        .settings
        .firstWhere((setting) => setting.name == "theme")
        .value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Other",
        ),
      ),
      body: SettingsList(
        applicationType: ApplicationType.material,
        sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                onToggle: (value) {
                  /*Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();*/
                  setState(() {
                    _darkTheme = value;
                  });
                  SettingListModel().setAt(
                    Provider.of<SettingListModel>(context, listen: false)
                        .settings
                        .indexWhere((setting) => setting.name == "theme"),
                    SettingModel("theme", value ? "darkMode" : "lightMode"),
                  );
                },
                initialValue: _darkTheme,
                leading: const Icon(Icons.dark_mode_rounded),
                title: const Text('Dark Mode'),
              ),
              SettingsTile(
                leading: const Icon(Icons.public_rounded),
                title: const Text("Github repo"),
                onPressed: (context) async {
                  if (!await launchUrl(_url,
                      mode: LaunchMode.externalApplication)) {
                    throw Exception('Could not launch $_url');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
