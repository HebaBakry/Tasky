import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

          displaySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFFFCFC),
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
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/Vector.svg',
                  width: 42,
                  height: 42,
                ),
                SizedBox(width: 16),
                Text('Tasky', style: Theme.of(context).textTheme.displayMedium),
              ],
            ),
            SizedBox(height: 108),
            Text(
              'Welcome to Tasky 👋🏻',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              'Your productivity journey starts here.',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: 16),
            ),
            SizedBox(height: 24),
            SvgPicture.asset('assets/images/pana.svg'),
            SizedBox(height: 28),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Full Name',
                style: Theme.of(
                  context,
                ).textTheme.displayMedium?.copyWith(fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(hintText: 'e.g. Heba Bakry'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return HomeScreen();
                    },
                  ),
                );
              },
              child: Text(
                'Let’s Get Started',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
