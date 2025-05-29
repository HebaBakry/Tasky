import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/components/custom_screen_top_bar.dart';
import 'package:tasky/components/custom_task_container.dart';
import 'package:tasky/models/task_model.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  List<TaskModel> tasks = [];

  getAllTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tasks = prefs.getString('tasks');
    if (tasks != null) {
      final allTasks = jsonDecode(tasks) as List<dynamic>;
      this.tasks = allTasks
          .map((task) => TaskModel.fromMap(task))
          .where((task) => task.isCompleted)
          .toList();
    } else {
      print('No tasks found');
    }
    setState(() {});
  }

  @override
  void initState() {
    print('Completed Tasks');
    getAllTasks();
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
              CustomScreenTopBar(title: 'Completed Tasks'),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return CustomTaskContainer(task: task);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
