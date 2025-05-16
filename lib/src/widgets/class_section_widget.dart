import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/class_model.dart';

class ClassSection extends StatelessWidget {
  final ClassModel classData;
  const ClassSection({required this.classData, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final c = classData;

    return Card(
      color: colorScheme.secondary,

      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 20, backgroundColor: Colors.grey[800]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(c.activityDate),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        c.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sport & Location
            Row(
              children: [
                const Icon(Icons.sports_tennis, size: 16),
                const SizedBox(width: 4),
                Text(c.sessionActivity),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Expanded(child: Text(c.sportsCenter.address)),
              ],
            ),
            const SizedBox(height: 12),

            // Courses & Mixed
            Row(
              children: [
                const Icon(Icons.equalizer, size: 16),
                const SizedBox(width: 4),
                Text(' ${c.academyType}'),
                const SizedBox(width: 16),
                const Icon(Icons.wc, size: 16),
                const SizedBox(width: 4),
                Text(c.category),
              ],
            ),
            const SizedBox(height: 12),

            // Bottom action row
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Participant indicator
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text('+${c.sessionActivity}'),
                  ],
                ),

                // Join vs Booked
                // if (!c.booked)
                //   ElevatedButton(
                //     onPressed: () {
                //       /* TODO: join logic */
                //     },
                //     style: ElevatedButton.styleFrom(
                //       shape: const StadiumBorder(),
                //       backgroundColor: colorScheme.primary,
                //     ),
                //     child: Text(
                //       'Join – \$${c.price}',
                //       style: const TextStyle(color: Colors.white),
                //     ),
                //   )
                // else
                //   Row(
                //     children: [
                //       Icon(Icons.check_circle, color: colorScheme.primary),
                //       const SizedBox(width: 4),
                //       Text(
                //         'Booked',
                //         style: TextStyle(
                //           color: colorScheme.primary,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ],
                //   ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String rawDate) {
    try {
      final parsed = DateTime.parse(rawDate);
      return DateFormat('EEEE, MMMM d, y').format(parsed);
    } catch (_) {
      return rawDate;
    }
  }
}
