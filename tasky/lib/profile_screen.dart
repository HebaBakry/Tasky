import 'package:flutter/material.dart';
import 'package:tasky/components/custom_screen_top_bar.dart';
import 'package:tasky/models/task_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 18),
              CustomScreenTopBar(title: 'My Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
