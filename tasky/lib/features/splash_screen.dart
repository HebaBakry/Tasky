import 'package:flutter/material.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/features/login/login_screen.dart';
import 'package:tasky/features/navigation/main_screen.dart';

class SplashScreen extends StatefulWidget {
  final String? userName;

  const SplashScreen({super.key, required this.userName});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              widget.userName != null ? MainScreen() : LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomSvgPicture.withoutColor(
          path: 'assets/images/Vector.svg',
          height: 63,
          width: 63,
        ),
      ),
    );
  }
}
