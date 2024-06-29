import 'package:flutter/material.dart';

typedef IntCallback = void Function(int val);

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key, required this.callback});

  final IntCallback callback;

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.assignment_outlined),
          label: 'Routines',
          selectedIcon: Icon(Icons.assignment_rounded),
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined),
          label: 'Exercises',
          selectedIcon: Icon(Icons.fitness_center_rounded),
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Calendar',
          selectedIcon: Icon(Icons.calendar_month_rounded),
        ),
        NavigationDestination(
          icon: Icon(Icons.accessibility_outlined),
          label: 'Body',
          selectedIcon: Icon(Icons.accessibility_rounded),
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_outlined),
          label: 'Other',
          selectedIcon: Icon(Icons.menu_rounded),
        ),
      ],
      selectedIndex: _selectedIndex,
      onDestinationSelected: (value) {
        widget.callback(value);
        setState(() {
          _selectedIndex = value;
        });
      },
    );
  }
}
