import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/user_activity_model.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _selectedFilter = 'All';

  List<UserActivity> _activities = [];

  Future<void> fetchActivities() async {
    // Simulated API response
    final response = [
      {
        "type": "login",
        "description": "You recently logged into your account",
        "device_type": "Android - Redmi Note 10",
        "timestamp":
            DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      },
      {
        "type": "match",
        "description": "You played a match at Court 3",
        "device_type": null,
        "timestamp":
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        "type": "class",
        "description": "You booked a tennis class at Arena Sports",
        "device_type": null,
        "timestamp":
            DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      },
      {
        "type": "unknown_type",
        "description": "An unknown activity",
        "device_type": null,
        "timestamp": DateTime.now().toIso8601String(),
      },
    ];

    setState(() {
      _activities = response.map((e) => UserActivity.fromJson(e)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  List<String> get _filterOptions => [
    'All',
    ...{for (var a in _activities) a.type},
  ];

  List<UserActivity> get _filteredActivities {
    if (_selectedFilter == 'All') return _activities;
    return _activities.where((a) => a.type == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Activity')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filter Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    popupMenuTheme: PopupMenuThemeData(
                      color: colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: PopupMenuButton<String>(
                    initialValue: _selectedFilter,
                    onSelected: (val) => setState(() => _selectedFilter = val),
                    itemBuilder:
                        (context) =>
                            _filterOptions
                                .map(
                                  (type) => PopupMenuItem(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: TextStyle(
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.primary),
                        borderRadius: BorderRadius.circular(12),
                        color: colorScheme.primary,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedFilter,
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Activity List
            Expanded(
              child:
                  _filteredActivities.isEmpty
                      ? const Center(child: Text('No activities found.'))
                      : ListView.separated(
                        itemCount: _filteredActivities.length,
                        separatorBuilder:
                            (context, index) => const Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Colors.grey,
                              indent: 15,
                              endIndent: 15,
                            ),
                        itemBuilder: (context, index) {
                          final activity = _filteredActivities[index];

                          String dateTimeStr = DateFormat(
                            'EEE, MMM d, h:mm a',
                          ).format(activity.timestamp);
                          String? deviceStr = activity.deviceType;
                          String subtitleText =
                              deviceStr != null && deviceStr.isNotEmpty
                                  ? "$deviceStr | $dateTimeStr"
                                  : dateTimeStr;

                          return ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                activity.icon,
                                color: theme.colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            title: Text(activity.description),
                            subtitle: Text(
                              subtitleText,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
