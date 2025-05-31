import 'package:flutter/material.dart';
import 'package:tasky/features/profile/profile_screen.dart';
import 'package:tasky/features/tasks/complete_tasks_screen.dart';
import 'package:tasky/features/home/home_screen.dart';
import 'package:tasky/features/tasks/todo_tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screens = [
    HomeScreen(),
    TasksScreen(),
    CompleteTasksScreen(),
    ProfileScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: screens[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.today_outlined),
            label: 'Todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Completed',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF15B86C),
        unselectedItemColor: Colors.white,
        backgroundColor: Color(0xFF181818),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
