import 'package:flutter/material.dart';
import '../../../models/class_model.dart';
import '../../../models/coach_model.dart';
import '../../../widgets/class_card.dart';

class AvailableClassesTab extends StatefulWidget {
  const AvailableClassesTab({super.key});

  @override
  State<AvailableClassesTab> createState() => _AvailableClassesTabState();
}

class _AvailableClassesTabState extends State<AvailableClassesTab> {
  // Move your list into mutable state
  List<ClassModel> classes = [
    ClassModel(
      dateGroup: 'Tomorrow',
      time: 'Wednesday, February 05 • 6:00pm',
      title: 'Beginners Social',
      sport: 'Padel',
      location: 'The Hook Club at Mottram Hall',
      courses: 0,
      mixed: true,
      coach: const CoachModel(name: 'Sam Brown'),
      spots: 6,
      price: 24,
      booked: false,
    ),
    ClassModel(
      dateGroup: 'Friday, February 08',
      time: 'Friday, February 07 • 6:00pm',
      title: 'Beginners Social',
      sport: 'Padel',
      location: 'The Hook Club at Mottram Hall',
      courses: 0,
      mixed: true,
      coach: const CoachModel(name: 'Sam Brown'),
      spots: 6,
      price: 24,
      booked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Group by dateGroup each build (or cache if you like)
    final grouped = <String, List<ClassModel>>{};
    for (final c in classes) {
      grouped.putIfAbsent(c.dateGroup, () => []).add(c);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final entry in grouped.entries) ...[
          Text(
            entry.key,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Render each card; you could also pass a callback down to ClassCard
          for (final cls in entry.value) ClassCard(classData: cls),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
