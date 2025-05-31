import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/enums/task_item_actions_enum.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';
import 'package:tasky/models/task_model.dart';

class TaskItemWidget extends StatelessWidget {
  const TaskItemWidget({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
  });

  final TaskModel model;
  final Function(bool?) onChanged;
  final Function(int) onDelete;
  final Function onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeController.isDark()
              ? Colors.transparent
              : Color(0xFFD1DAD6),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 8),
          Checkbox(
            value: model.isCompleted,
            onChanged: (bool? value) => onChanged(value),
            activeColor: Color(0xFF15B86C),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: model.isCompleted
                      ? Theme.of(context).textTheme.titleLarge
                      : Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                ),
                if (model.description.isNotEmpty)
                  Text(
                    model.description,
                    style: TextStyle(
                      color: Color(0xFFC6C6C6),
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          PopupMenuButton<TaskItemActionsEnum>(
            icon: Icon(
              Icons.more_vert,
              color: ThemeController.isDark()
                  ? (model.isCompleted ? Color(0xFFA0A0A0) : Color(0xFFC6C6C6))
                  : (model.isCompleted ? Color(0xFF6A6A6A) : Color(0xFF3A4640)),
            ),
            onSelected: (value) async {
              switch (value) {
                case TaskItemActionsEnum.markAsDone:
                  onChanged(!model.isCompleted);
                case TaskItemActionsEnum.delete:
                  await _showAlertDialog(context);
                case TaskItemActionsEnum.edit:
                  final result = await _showButtonSheet(context, model);
                  if (result == true) {
                    onEdit();
                  }
              }
            },
            itemBuilder: (context) => TaskItemActionsEnum.values.map((e) {
              return PopupMenuItem<TaskItemActionsEnum>(
                value: e,
                child: Text(
                  e.name,
                  style: TextStyle(
                    color: ThemeController.isDark()
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<String?> _showAlertDialog(context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Text('Are you sure you want to delete this task '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onDelete(model.id);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showButtonSheet(BuildContext context, TaskModel model) {
    TextEditingController taskNameController = TextEditingController(
      text: model.name,
    );
    TextEditingController taskDescriptionController = TextEditingController(
      text: model.description,
    );
    GlobalKey<FormState> key = GlobalKey<FormState>();
    bool isHighPriority = model.isHighPriority;
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      CustomTextFormField(
                        controller: taskNameController,
                        title: "Task Name",
                        hintText: 'Finish UI design for login screen',
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Task Name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        title: "Task Description",
                        controller: taskDescriptionController,
                        maxLines: 5,
                        hintText:
                            'Finish onboarding UI and hand off to devs by Thursday.',
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'High Priority',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Switch(
                            value: isHighPriority,
                            onChanged: (bool value) {
                              setState(() {
                                isHighPriority = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            MediaQuery.of(context).size.width,
                            40,
                          ),
                        ),
                        onPressed: () async {
                          if (key.currentState?.validate() ?? false) {
                            final taskJson = PreferencesManager().getString(
                              StorageKey.tasks,
                            );

                            List<dynamic> listTasks = [];

                            if (taskJson != null) {
                              listTasks = jsonDecode(taskJson);
                            }

                            TaskModel newModel = TaskModel(
                              id: model.id,
                              name: taskNameController.text,
                              description: taskDescriptionController.text,
                              isHighPriority: isHighPriority,
                              isCompleted: model.isCompleted,
                            );

                            final item = listTasks.firstWhere(
                              (e) => e['id'] == model.id,
                            );
                            final int index = listTasks.indexOf(item);
                            listTasks[index] = newModel.toMap();

                            final taskEncode = jsonEncode(listTasks);
                            await PreferencesManager().setString(
                              StorageKey.tasks,
                              taskEncode,
                            );

                            Navigator.of(context).pop(true);
                          }
                        },
                        label: Text('Edit Task'),
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
