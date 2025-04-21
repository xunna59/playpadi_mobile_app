import 'package:flutter/material.dart';
// import '../controllers/event_centers_controller.dart';
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

      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top image section remains unchanged.
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: const Image(
              image: AssetImage('assets/background/book_court.png'),
              fit: BoxFit.cover,
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(eventCenter.price),
                    ],
                  ),
                ),
                // Location section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(eventCenter.location),
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
