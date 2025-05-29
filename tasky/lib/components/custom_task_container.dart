import 'package:flutter/material.dart';
import 'package:tasky/models/task_model.dart';

class CustomTaskContainer extends StatelessWidget {
  const CustomTaskContainer({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        height: 56,
        decoration: BoxDecoration(
          color: Color(0xFF282828),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Checkbox(value: false, onChanged: (value) {}),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    task.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.more_vert),
          ],
        ),
      ),
    );
  }
}
