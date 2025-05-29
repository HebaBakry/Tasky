import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/components/custom_text_field.dart';
import 'package:tasky/models/task_mode.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  bool isON = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 32,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Text(
                          'New Task',
                          style: Theme.of(
                            context,
                          ).textTheme.displayMedium?.copyWith(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    text: 'Task Name',
                    controller: taskNameController,
                    hintText: 'Finish UI design for login screen',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a task name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    text: 'Task Description',
                    controller: taskDescriptionController,
                    hintText:
                        'Finish onboarding UI and hand off to devs by Thursday.',
                    maxLines: 5,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'High Priority',
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(fontSize: 16),
                      ),
                      Switch(
                        value: isON,
                        onChanged: (value) {
                          setState(() {
                            isON = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 97),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final String? list = prefs.getString('tasks');
                        List<dynamic> tasks = [];
                        if (list != null) {
                          tasks = jsonDecode(list);
                        }

                        TaskModel newTask = TaskModel(
                          id: tasks.length + 1,
                          name: taskNameController.text,
                          description: taskDescriptionController.text,
                          isHighPriority: isON,
                        );
                        tasks.add(newTask.toMap());
                        await prefs.setString('tasks', jsonEncode(tasks));
                        taskNameController.clear();
                        taskDescriptionController.clear();
                        Navigator.pop(context, true);
                      }
                    },
                    icon: Icon(Icons.add, size: 16),
                    label: Text('Add Task'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
