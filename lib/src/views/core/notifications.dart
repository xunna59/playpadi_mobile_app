import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/notification_controller.dart';
import '../../models/notification_model.dart';
import '../../routes/app_routes.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationController _notificationController =
      NotificationController();
  late Future<List<NotificationData>> _futureNotifications;

  @override
  void initState() {
    super.initState();
    _futureNotifications = _notificationController.fetchNotifications();
  }

  Map<String, List<NotificationData>> groupByDate(
    List<NotificationData> notifications,
  ) {
    Map<String, List<NotificationData>> grouped = {};
    final now = DateTime.now();
    for (var n in notifications) {
      final date = DateTime.parse(n.createdAt).toLocal();
      String key;

      if (DateUtils.isSameDay(now, date)) {
        key = 'Today';
      } else if (DateUtils.isSameDay(
        now.subtract(const Duration(days: 1)),
        date,
      )) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMMM dd, yyyy').format(date);
      }

      grouped.putIfAbsent(key, () => []).add(n);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Notifications'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<NotificationData>>(
        future: _futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load notifications.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notifications.'));
          }

          final groupedNotifications = groupByDate(snapshot.data!);

          return ListView(
            padding: const EdgeInsets.all(12),
            children:
                groupedNotifications.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        child: Text(
                          entry.key,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...entry.value.map((notification) {
                        final isRead = notification.isRead;
                        final createdTime = DateFormat('hh:mm a').format(
                          DateTime.parse(notification.createdAt).toLocal(),
                        );

                        return Column(
                          children: [
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              color:
                                  isRead
                                      ? colorScheme.surface
                                      : colorScheme.tertiaryContainer,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () async {
                                  // final payload = {
                                  //   'notificationId': notification.id,
                                  // };

                                  // final response = await _notificationController
                                  //     .markNotificationRead(payload);

                                  // setState(() {
                                  //   _futureNotifications =
                                  //       _notificationController
                                  //           .fetchNotifications();
                                  // });

                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.notification_details,
                                    arguments: notification,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Icon(
                                          Icons.notifications_none,
                                          size: 24,
                                          color:
                                              isRead
                                                  ? colorScheme.onSurface
                                                      .withOpacity(0.5)
                                                  : colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notification.title,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                    isRead
                                                        ? FontWeight.normal
                                                        : FontWeight.bold,
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              notification.description,
                                              maxLines:
                                                  2, // or 1 depending on how much you want to show
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: colorScheme.onSurface
                                                    .withOpacity(0.7),
                                              ),
                                            ),

                                            const SizedBox(height: 4),
                                            Text(
                                              createdTime,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: colorScheme.onSurface
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!isRead)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 8,
                                            top: 4,
                                          ),
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                              199,
                                              3,
                                              125,
                                              1,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              indent: 22,
                              endIndent: 22,
                              thickness: 0.2,
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
