import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/components/custom_screen_top_bar.dart';
import 'package:tasky/components/custom_task_container.dart';
import 'package:tasky/models/task_model.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<TaskModel> tasks = [];

  getAllTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tasks = prefs.getString('tasks');
    if (tasks != null) {
      final allTasks = jsonDecode(tasks) as List<dynamic>;
      this.tasks = allTasks
          .map((task) => TaskModel.fromMap(task))
          .where((task) => task.isCompleted == false)
          .toList();
    } else {
      print('No tasks found');
    }
    setState(() {});
  }

  @override
  void initState() {
    print('To Do Screen');
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
              CustomScreenTopBar(title: 'To Do Tasks'),
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
