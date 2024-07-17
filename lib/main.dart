import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/screens/body.dart';
import 'package:workout_tracker/screens/calendar.dart';
import 'package:workout_tracker/screens/exercises.dart';
import 'package:workout_tracker/screens/other.dart';
import 'package:workout_tracker/screens/routines.dart';
import 'package:workout_tracker/theme/theme_provider.dart';
import 'package:workout_tracker/widgets/bottom_navbar.dart';

import 'models/body_list_model.dart';
import 'models/calendar_event_list_model.dart';
import 'models/exercise_list_model.dart';
import 'models/routine_list_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init file data
  await RoutineListModel().init();
  await ExerciseListModel().init();
  await CalendarEventListModel().init();
  await BodyListModel().init();

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
        ChangeNotifierProvider(
          create: (context) => CalendarEventListModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => BodyListModel(),
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
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // default screen value
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> navbarScreens = <Widget>[
      const Routines(),
      const Exercises(),
      const Calendar(),
      const Body(),
      const Other(),
    ];

    return Scaffold(
      body: navbarScreens.elementAt(_selectedIndex),
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
