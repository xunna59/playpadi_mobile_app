import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/user_activity_controller.dart';
import '../../../../models/user_activity_model.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final userActivityController _controller = userActivityController();
  String _selectedFilter = 'All Activities';
  List<UserActivity> _activities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    final activities = await _controller.fetchUserActivity();
    setState(() {
      _activities = activities;
      _isLoading = false;
    });
  }

  List<String> get _filterOptions => [
    'All Activities',
    ...{for (var a in _activities) a.type},
  ];

  List<UserActivity> get _filteredActivities {
    if (_selectedFilter == 'All Activities') return _activities;
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
            /// Filter Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const Text(
                //   'Filter:',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                // ),
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

            /// Activity List
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredActivities.isEmpty
                      ? const Center(child: Text('No activities found.'))
                      : ListView.separated(
                        itemCount: _filteredActivities.length,
                        separatorBuilder:
                            (_, __) => const Divider(
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

                          String subtitleText =
                              activity.device != null &&
                                      activity.device!.isNotEmpty
                                  ? "${activity.device} | $dateTimeStr"
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
