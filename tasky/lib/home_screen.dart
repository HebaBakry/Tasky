import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky/add_new_task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                        'Good Evening ,Heba',
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return AddNewTask();
              },
            ),
          );
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add New Task',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        backgroundColor: Color(0xFF15B86C),
      ),
    );
  }
}
