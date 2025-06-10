import 'package:flutter/material.dart';

import '../../../../../core/constants.dart';
import '../../../../../models/class_model.dart';

class PlayersList extends StatelessWidget {
  final ClassModel classData;

  const PlayersList({super.key, required this.classData});

  @override
  Widget build(BuildContext context) {
    final players = classData.academy_students.students;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Players", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child:
              players.isEmpty
                  ? const Center(child: Text("No players found"))
                  : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: players.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, index) {
                      final player = players[index];

                      final image = player.displayPicture ?? '';
                      final name = player.firstName;

                      return Column(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                image.isNotEmpty
                                    ? NetworkImage('${display_picture}${image}')
                                    : const AssetImage('assets/images/user.png')
                                        as ImageProvider,
                            radius: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(name, style: const TextStyle(fontSize: 12)),
                        ],
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
