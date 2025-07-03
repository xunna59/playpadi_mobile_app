import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import 'package:intl/intl.dart'; // For formatting dates

class NotificationDetailsScreen extends StatelessWidget {
  final NotificationData notification;

  const NotificationDetailsScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: colorScheme.secondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  DateFormat(
                    'EEEE, MMMM d, y – hh:mm a',
                  ).format(notification.parsedCreatedAt),
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  notification.description,
                  textAlign: TextAlign.justify, // Justifies the text
                  style: TextStyle(
                    fontSize: 14,
                    height: 2.0,
                    color: colorScheme.onSurface,
                  ),
                ),

                // const SizedBox(height: 30),
                // Row(
                //   children: [
                //     const Icon(Icons.check_circle_outline, size: 20),
                //     const SizedBox(width: 8),
                //     Text(
                //       notification.isRead ? 'Read' : 'Unread',
                //       style: TextStyle(
                //         fontSize: 14,
                //         color:
                //             notification.isRead ? Colors.green : Colors.orange,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
