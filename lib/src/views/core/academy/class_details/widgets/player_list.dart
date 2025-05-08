import 'package:flutter/material.dart';

class PlayersList extends StatelessWidget {
  const PlayersList({super.key});

  final List<Map<String, String>> players = const [
    {"name": "Judith", "image": "https://i.pravatar.cc/101"},
    {"name": "Kristin", "image": "https://i.pravatar.cc/102"},
    {"name": "Courtney", "image": "https://i.pravatar.cc/103"},
    {"name": "Audrey", "image": "https://i.pravatar.cc/104"},
    {"name": "Gladys", "image": "https://i.pravatar.cc/105"},
    {"name": "Judith", "image": "https://i.pravatar.cc/101"},
    {"name": "Kristin", "image": "https://i.pravatar.cc/102"},
    {"name": "Courtney", "image": "https://i.pravatar.cc/103"},
    {"name": "Audrey", "image": "https://i.pravatar.cc/104"},
    {"name": "Gladys", "image": "https://i.pravatar.cc/105"},
    {"name": "Judith", "image": "https://i.pravatar.cc/101"},
    {"name": "Kristin", "image": "https://i.pravatar.cc/102"},
    {"name": "Courtney", "image": "https://i.pravatar.cc/103"},
    {"name": "Audrey", "image": "https://i.pravatar.cc/104"},
    {"name": "Gladys", "image": "https://i.pravatar.cc/105"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Players", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: players.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, index) {
              final player = players[index];
              return Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(player['image']!),
                    radius: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(player['name']!, style: const TextStyle(fontSize: 12)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
