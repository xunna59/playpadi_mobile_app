import 'package:flutter/material.dart';

import '../../../../../core/constants.dart';
import '../../../../../models/class_model.dart';

class CoachInfo extends StatelessWidget {
  final ClassModel classData;
  const CoachInfo({super.key, required this.classData});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            classData.coach.displayPicture != null
                ? NetworkImage(
                  '${display_picture}${classData.coach.displayPicture}',
                )
                : null,
        backgroundColor: Colors.grey[800],
      ),
      title: Text('${classData.coach.firstName} ${classData.coach.lastName}'),
      subtitle: Text(classData.sportsCenter.name),
    );
  }
}
