import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/features/tasks/task_controller.dart';
import 'package:tasky/features/tasks/high_priority_screen.dart';

class HighPriorityTasksWidget extends StatelessWidget {
  const HighPriorityTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder:
          (BuildContext context, TaskController controller, Widget? child) {
            final tasksList = controller.tasks;

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'High Priority Tasks',
                            style: TextStyle(
                              color: Color(0xFF15B86C),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (controller.highPriorityTasks.isEmpty)
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No high priority tasks',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          )
                        else
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                tasksList.reversed
                                        .where((e) => e.isHighPriority)
                                        .length >
                                    4
                                ? 4
                                : tasksList.reversed
                                      .where((e) => e.isHighPriority)
                                      .length,
                            itemBuilder: (BuildContext context, int index) {
                              final task = tasksList.reversed
                                  .where((e) => e.isHighPriority)
                                  .toList()[index];
                              return Row(
                                children: [
                                  Checkbox(
                                    value: task.isCompleted,
                                    onChanged: (bool? value) {
                                      final index = tasksList.indexWhere(
                                        (e) => e.id == task.id,
                                      );
                                      controller.doneTask(value, index);
                                    },
                                    activeColor: Color(0xFF15B86C),
                                  ),
                                  Flexible(
                                    child: Text(
                                      task.name,
                                      style: task.isCompleted
                                          ? Theme.of(
                                              context,
                                            ).textTheme.titleLarge
                                          : Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return HighPriorityScreen();
                          },
                        ),
                      );
                      controller.loadTask();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 56,
                        width: 48,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ThemeController.isDark()
                                ? Color(0xFF6E6E6E)
                                : Color(0xFFD1DAD6),
                          ),
                        ),
                        child: CustomSvgPicture(
                          path: "assets/images2/arrow_up_right.svg",
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}
