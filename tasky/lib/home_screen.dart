import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/add_new_task_screen.dart';
import 'package:tasky/components/custom_task_container.dart';
import 'package:tasky/models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  List<TaskModel> tasks = [];
  List<TaskModel> highPriorityTasks = [];

  @override
  void initState() {
    getUserName();
    getAllTasks();
    super.initState();
  }

  getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName');
    setState(() {});
  }

  getAllTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tasks = prefs.getString('tasks');
    if (tasks != null) {
      print(tasks);
      final allTasks = jsonDecode(tasks) as List<dynamic>;
      this.tasks = allTasks.map((task) => TaskModel.fromMap(task)).toList();
      highPriorityTasks = this.tasks
          .where((task) => task.isHighPriority)
          .toList();
    } else {
      print('No tasks found');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/person.jpg'),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Evening ,$userName',
                            style: Theme.of(
                              context,
                            ).textTheme.displayMedium?.copyWith(fontSize: 16),
                          ),
                          Text(
                            'One task at a time.One step closer.',
                            style: Theme.of(
                              context,
                            ).textTheme.displayMedium?.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/images/Icon.svg',
                      width: 15,
                      height: 15,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Yuhuu ,Your work Is\nalmost done! 👋🏻',
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: 32),
                ),
                SizedBox(height: 8),
                Container(
                  height: 180,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF282828),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "High Priority Tasks",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 130,
                        child: ListView.builder(
                          itemCount: highPriorityTasks.length,
                          itemBuilder: (context, index) {
                            final task = highPriorityTasks[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Checkbox(value: false, onChanged: (value) {}),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          task.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium
                                              ?.copyWith(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          task.description,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'My Tasks',
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: 20),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 400,
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNewTask()),
          );
          if (shouldRefresh == true) {
            getAllTasks();
          }
        },
        icon: Icon(Icons.add, size: 20, color: Colors.white),
        label: Text(
          'Add New Task',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        backgroundColor: Color(0xFF15B86C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
    );
  }
}
