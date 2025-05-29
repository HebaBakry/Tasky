import 'package:flutter/material.dart';

class CustomScreenTopBar extends StatelessWidget {
  const CustomScreenTopBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.arrow_back, size: 25, color: Colors.white),

        SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
