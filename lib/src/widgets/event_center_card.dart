import 'package:flutter/material.dart';
// import '../controllers/event_centers_controller.dart';
import '../core/constants.dart';
import '../models/event_center_model.dart'; // Import the controller

class EventCenterCard extends StatelessWidget {
  final EventCenter eventCenter;

  const EventCenterCard({required this.eventCenter, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: colorScheme.secondary,

      elevation: 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top image section remains unchanged.
          Container(
            height: 180,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                '$imageBaseUrl${eventCenter.coverImage}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Wrap all body content in one Container with a white background
          Container(
            //   color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with name and price
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          eventCenter.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text('₦${eventCenter.sessionPrice}/hr'),
                    ],
                  ),
                ),
                // Location section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(eventCenter.address),
                ),
                // Available times as chips row
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children:
                        eventCenter.availableTimes
                            .map(
                              (time) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Chip(
                                  label: Text(
                                    time,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: colorScheme.primary,
                                  side: BorderSide.none,
                                  //  surfaceTintColor: Colors.white,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
