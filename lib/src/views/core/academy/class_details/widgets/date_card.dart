import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import '../../../../../models/class_model.dart';

class DateCard extends StatelessWidget {
  final ClassModel classData;
  const DateCard({super.key, required this.classData});

  Event buildEvent() {
    final DateTime startTime = DateTime.parse(classData.activityDate);
    final DateTime endTime = startTime.add(
      Duration(minutes: classData.sessionDuration),
    );

    return Event(
      title: classData.title,
      description: 'Court One • Outdoor • Double',
      location: 'Court One',
      startDate: startTime,
      endDate: endTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.secondary,
      child: ListTile(
        title: Text("${classData.title} "),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 7),
            GestureDetector(
              onTap: () => Add2Calendar.addEvent2Cal(buildEvent()),
              child: const Text(
                "Add to calendar",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 7),
            const Text("Court One • Outdoor • Double"),
          ],
        ),
        trailing: Column(
          children: [
            const SizedBox(height: 5),
            const Icon(Icons.access_time),
            const SizedBox(height: 5),
            Text("${classData.sessionDuration} mins"),
          ],
        ),
      ),
    );
  }
}
