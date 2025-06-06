import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/features/tasks/task_controller.dart';
import 'package:tasky/core/widgets/task_list_widget.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});
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
              'To Do Tasks',
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
                          ? Center(child: CircularProgressIndicator())
                          : TaskListWidget(
                              tasks: controller.todoTasks,
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
                    ),
                  );
                },
          ),
        ],
      ),
    );
  }
}
