import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/features/tasks/task_controller.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/core/widgets/task_list_widget.dart';

class HighPriorityScreen extends StatelessWidget {
  const HighPriorityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('High Priority Tasks')),
      body: ChangeNotifierProvider<TaskController>(
        create: (context) => TaskController()..init(),
        child: Consumer<TaskController>(
          builder:
              (BuildContext context, TaskController controller, Widget? child) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: controller.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : TaskListWidget(
                          tasks: controller.highPriorityTasks,
                          onTap: (value, index) async {
                            controller.highPriorityTasks[index!].isCompleted =
                                value ?? false;

                            final allData = PreferencesManager().getString(
                              StorageKey.tasks,
                            );
                            if (allData != null) {
                              List<TaskModel> allDataList =
                                  (jsonDecode(allData) as List)
                                      .map(
                                        (element) => TaskModel.fromMap(element),
                                      )
                                      .toList();

                              final int newIndex = allDataList.indexWhere(
                                (e) =>
                                    e.id ==
                                    controller.highPriorityTasks[index].id,
                              );
                              allDataList[newIndex] =
                                  controller.highPriorityTasks[index];
                              await PreferencesManager().setString(
                                StorageKey.tasks,
                                jsonEncode(
                                  allDataList.map((e) => e.toMap()).toList(),
                                ),
                              );

                              controller.loadTask();
                            }
                          },
                          emptyMessage: 'No Task Found',
                          onDelete: (int? id) {
                            controller.deleteTask(id);
                          },
                          onEdit: () {
                            controller.loadTask();
                          },
                        ),
                );
              },
        ),
      ),
    );
  }
}
