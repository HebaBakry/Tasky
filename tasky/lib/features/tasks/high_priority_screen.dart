import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/features/tasks/task_controller.dart';
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
                            controller.doneTask(value, index);
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
