import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/screens/body.dart';
import 'package:workout_tracker/screens/calendar.dart';
import 'package:workout_tracker/screens/exercises.dart';
import 'package:workout_tracker/screens/other.dart';
import 'package:workout_tracker/screens/routines.dart';
import 'package:workout_tracker/theme/theme_provider.dart';
import 'package:workout_tracker/theme/themes.dart';
import 'package:workout_tracker/widgets/bottom_navbar.dart';

import 'models/exercise_list_model.dart';
import 'models/routine_list_model.dart';
import 'models/screen_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init file data
  await RoutineListModel().init();
  await ExerciseListModel().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RoutineListModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExerciseListModel(),
        ),
      ],
      child: const WorkoutTracker(),
    ),
  );
}

class WorkoutTracker extends StatelessWidget {
  const WorkoutTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const HomePage(title: 'Workout Tracker'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> navbarScreens = <Widget>[
      Routines(
        context: context,
      ),
      Exercises(
        context: context,
      ),
      Calendar(
        context: context,
      ),
      Body(
        context: context,
      ),
      Other(
        context: context,
      ),
    ];

    final bool isLightMode = Provider.of<ThemeProvider>(context).themeData ==
        CustomThemes().lightMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Tracker"),
        actions: [
          Switch(
            value: isLightMode,
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: navbarScreens.elementAt(_selectedIndex),
      floatingActionButton:
          ((navbarScreens.elementAt(_selectedIndex)) as ScreenModel)
              .floatingActionButton,
      bottomNavigationBar: BottomNavbar(
        callback: (int val) {
          setState(() {
            _selectedIndex = val;
          });
        },
      ),
    );
  }
}
