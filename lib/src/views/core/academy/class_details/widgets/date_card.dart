import 'package:flutter/material.dart';

import '../../../../../models/class_model.dart';

class DateCard extends StatelessWidget {
  final ClassModel classData;
  const DateCard({super.key, required this.classData});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.secondary,
      child: ListTile(
        title: const Text("Wednesday, February 08 | 6:00pm"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 7),
            Text("Add to calendar", style: TextStyle(color: Colors.blue)),
            SizedBox(height: 7),
            Text("Court One • Outdoor • Double"),
          ],
        ),
        trailing: Column(
          children: [
            SizedBox(height: 5),
            const Icon(Icons.access_time),
            SizedBox(height: 5),
            Text("${classData.sessionDuration} mins"),
          ],
        ),
      ),
    );
  }
}
