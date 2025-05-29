import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/home_screen.dart';
import 'package:tasky/login_screen.dart';
import 'package:tasky/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userName = prefs.getString('userName');
  runApp(MyApp(userName: userName));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.userName});
  final String? userName;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF181818),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF15B86C),
            foregroundColor: Color(0xFFFFFCFC),
            fixedSize: Size(MediaQuery.of(context).size.width, 40),
          ),
        ),
        textTheme: TextTheme(
          displayMedium: TextStyle(
            fontSize: 28,
            color: Color(0xFFFFFCFC),
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6C6C6C),
          ),
          displaySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFFFCFC),
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF15B86C),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Color(0xFF282828),
          filled: true,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6D6D6D),
          ),
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        switchTheme: SwitchThemeData(
          trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Color(0xFF15B86C)
                : Colors.white,
          ),
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Colors.white
                : Color(0xFF9E9E9E),
          ),
          trackOutlineColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Colors.transparent
                : Color(0xFF9E9E9E),
          ),
          trackOutlineWidth: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected) ? 0 : 2,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF181818),
          selectedItemColor: Color(0xFF15B86C),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: userName != null ? MainScreen() : LoginScreen(),
    );
  }
}
