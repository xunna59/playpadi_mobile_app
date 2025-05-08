import 'package:flutter/material.dart';

import '../../../../../models/class_model.dart';

class CoachInfo extends StatelessWidget {
  final ClassModel classData;
  const CoachInfo({super.key, required this.classData});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: NetworkImage(
          'https://i.pravatar.cc/300',
        ), // Replace with coach photo URL
      ),
      title: Text('${classData.coach.firstName} ${classData.coach.lastName}'),
      subtitle: const Text("Coach verified\nThe Hook Club at Mottram Hall"),
    );
  }
}
