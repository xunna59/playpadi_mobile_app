import 'package:flutter/material.dart';
import '../controllers/academy_controller.dart';
import '../models/class_model.dart';
import '../models/coach_model.dart';
import 'class_section_widget.dart';

class AcademySection extends StatefulWidget {
  AcademySection({Key? key}) : super(key: key);

  @override
  State<AcademySection> createState() => _AcademySectionState();
}

class _AcademySectionState extends State<AcademySection> {
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
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _academyController.getAcademyClasses();
      setState(() {
        _academyClass = data;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
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
      return const Center(child: Text('No classes available.'));
    }

    final grouped = <String, List<ClassModel>>{};
    for (final c in _academyClass) {
      grouped.putIfAbsent(c.activityDate, () => []).add(c);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final entry in grouped.entries) ...[
          Text(
            entry.key,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Render each card; you could also pass a callback down to ClassCard
          for (final cls in entry.value) ClassSection(classData: cls),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
