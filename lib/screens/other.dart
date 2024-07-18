import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:workout_tracker/theme/theme_provider.dart';

import '../theme/themes.dart';

class Other extends StatefulWidget {
  const Other({super.key});

  @override
  State<Other> createState() => _OtherState();
}

class _OtherState extends State<Other> {
  bool _darkTheme = false;

  @override
  void initState() {
    super.initState();
    _darkTheme = Provider.of<ThemeProvider>(context, listen: false).themeData ==
        CustomThemes().darkMode;
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
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                  setState(() {
                    _darkTheme = value;
                  });
                  developer.log(value.toString());
                },
                initialValue: _darkTheme,
                leading: const Icon(Icons.dark_mode_rounded),
                title: const Text('Dark Mode'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
