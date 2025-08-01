import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../controllers/academy_controller.dart';
import '../../../models/class_model.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/class_card.dart';

class UserClassesTab extends StatefulWidget {
  const UserClassesTab({super.key});

  @override
  State<UserClassesTab> createState() => _UserClassesTabState();
}

class _UserClassesTabState extends State<UserClassesTab> {
  final AcademyController _academyController = AcademyController();

  List<ClassModel> _academyClass = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _academyController.getAcademyClasses();
      if (!mounted) return;

      setState(() {
        _academyClass = data.where((c) => c.joinedStatus == true).toList();
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
      });
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Error loading classes:\n$_error'));
    }

    if (_academyClass.isEmpty) {
      return const Center(child: Text('You haven’t joined any classes yet.'));
    }

    final grouped = <String, List<ClassModel>>{};
    for (final c in _academyClass) {
      grouped.putIfAbsent(c.activityDate, () => []).add(c);
    }

    return RefreshIndicator(
      onRefresh: _fetchClasses,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final entry in grouped.entries) ...[
            Text(
              _formatDate(entry.key),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (final cls in entry.value)
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.classDetailsScreen,
                    arguments: cls,
                  );
                  if (result == true) {
                    _fetchClasses();
                  }
                },
                child: ClassCard(classData: cls),
              ),
            const SizedBox(height: 16),
          ],
        ],
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
