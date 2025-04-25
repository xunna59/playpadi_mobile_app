import 'package:flutter/material.dart';
import '../models/match_model.dart';

class AvailableMatchCard extends StatelessWidget {
  final MatchModel match;

  const AvailableMatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.secondary,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.primary),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date & Time
            Text(
              '${match.dateText} – ${match.timeText}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),

            // Type & Availability
            Row(
              children: [
                const Icon(Icons.sports_tennis, size: 16),
                const SizedBox(width: 4),
                Text(match.matchLevel, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 16),
                const Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 4),
                Text(match.availability, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),

            // Players
            Row(
              children:
                  match.players.map((player) {
                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 44, // radius * 2 + padding
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  player.avatarUrl != null
                                      ? NetworkImage(player.avatarUrl!)
                                      : null,
                              child:
                                  player.avatarUrl == null
                                      ? const Icon(
                                        Icons.add,
                                        color: Colors.black,
                                      )
                                      : null,
                            ),
                          ),

                          const SizedBox(height: 4),
                          Text(
                            player.name,
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            player.rating.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 12),

            // Club & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                  backgroundImage: AssetImage(
                    'assets/images/default_avatar.png',
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ), // will show on top
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match.courtName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      match.distanceText,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '\$${match.price} – ${match.duration}mins',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
