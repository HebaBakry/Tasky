import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/features/tasks/task_controller.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/core/widgets/task_list_widget.dart';

class CompleteTasksScreen extends StatelessWidget {
  const CompleteTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskController>(
      create: (context) => TaskController()..init(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Completed Tasks',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Consumer<TaskController>(
            builder:
                (
                  BuildContext context,
                  TaskController controller,
                  Widget? child,
                ) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: controller.isLoading
                          ? Center(child: CircularProgressIndicator(value: 20))
                          : TaskListWidget(
                              tasks: controller.completedTasks,
                              onTap: (value, index) async {
                                controller.completedTasks[index!].isCompleted =
                                    value ?? false;

                                final allData = PreferencesManager().getString(
                                  StorageKey.tasks,
                                );

                                if (allData != null) {
                                  List<TaskModel> allDataList =
                                      (jsonDecode(allData) as List)
                                          .map(
                                            (element) =>
                                                TaskModel.fromMap(element),
                                          )
                                          .toList();
                                  final int newIndex = allDataList.indexWhere(
                                    (e) =>
                                        e.id ==
                                        controller.completedTasks[index].id,
                                  );
                                  allDataList[newIndex] =
                                      controller.completedTasks[index];

                                  await PreferencesManager().setString(
                                    StorageKey.tasks,
                                    jsonEncode(
                                      allDataList
                                          .map((e) => e.toMap())
                                          .toList(),
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
                    ),
                  );
                },
          ),
        ],
      ),
    );
  }
}
