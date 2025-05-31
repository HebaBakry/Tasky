import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';
import 'package:tasky/features/add_task/add_task_controller.dart';
import 'package:tasky/models/task_model.dart';

class AddNewTask extends StatelessWidget {
  AddNewTask({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Task')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18),
                  CustomTextFormField(
                    title: 'Task Name',
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
                  CustomTextFormField(
                    title: 'Task Description',
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
                      Selector<AddTaskController, bool>(
                        selector: (context, AddTaskController controller) =>
                            controller.isON,
                        builder: (BuildContext context, bool isON, Widget? child) {
                          final controller = context.read<AddTaskController>();
                          //I don't want this widget to rebuild when the controller changes.
                          return Switch(
                            value: isON,
                            onChanged: (value) {
                              controller.toggleSwitch(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 97),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 40),
                    ),
                    onPressed: () async {
                      final isON = context.read<AddTaskController>().isON;
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
