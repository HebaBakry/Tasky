import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';

class TaskController with ChangeNotifier {
  List<TaskModel> tasksList = [];
  List<TaskModel> tasks = [];
  List<TaskModel> highPriorityTasks = [];
  List<TaskModel> completedTasks = [];
  List<TaskModel> todoTasks = [];
  bool isLoading = false;
  int totalTask = 0;
  int totalDoneTasks = 0;
  double percent = 0;

  init() {
    loadTask();
  }

  void loadTask() async {
    isLoading = true;

    final finalTask = PreferencesManager().getString(StorageKey.tasks);
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      tasks = taskAfterDecode
          .map((element) => TaskModel.fromMap(element))
          .toList();
      highPriorityTasks = tasks
          .where((element) => element.isHighPriority)
          .toList();
      completedTasks = tasks.where((element) => element.isCompleted).toList();
      todoTasks = tasks.where((element) => !element.isCompleted).toList();
      calculatePercent();
    }

    isLoading = false;

    notifyListeners();
  }

  void _loadData() {
    highPriorityTasks = tasks
        .where((element) => element.isHighPriority)
        .toList();
    completedTasks = tasks.where((element) => element.isCompleted).toList();
    todoTasks = tasks.where((element) => !element.isCompleted).toList();
  }

  calculatePercent() {
    totalTask = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isCompleted).length;
    percent = totalTask == 0 ? 0 : totalDoneTasks / totalTask;
  }

  doneTask(bool? value, int? index) async {
    tasks[index!].isCompleted = value ?? false;
    calculatePercent();

    final updatedTask = tasks.map((element) => element.toMap()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    // _loadData();
    notifyListeners();
  }

  deleteTask(int? id) async {
    if (id == null) return;
    tasks.removeWhere((task) => task.id == id);
    calculatePercent();
    final updatedTask = tasks.map((element) => element.toMap()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    if (tasks.isEmpty) {
      highPriorityTasks.clear();
      completedTasks.clear();
      todoTasks.clear();
    } else {
      _loadData();
    }

    notifyListeners();
  }
}
