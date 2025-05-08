import 'package:flutter/material.dart';
import '../../../controllers/tutorial_controller.dart';
import '../../../models/youtube_tutorials_model.dart';
import '../../../widgets/tutorials_card.dart';

class YouTubeTutorialsTab extends StatefulWidget {
  const YouTubeTutorialsTab({super.key});

  @override
  State<YouTubeTutorialsTab> createState() => _YouTubeTutorialsTabState();
}

class _YouTubeTutorialsTabState extends State<YouTubeTutorialsTab> {
  final TutorialService _tutorialService = TutorialService();
  List<TutorialModel> _tutorials = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTutorials();
  }

  Future<void> _fetchTutorials() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _tutorialService.fetchYoutubeTutorials();
      setState(() {
        _tutorials = data;
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
      return Center(child: Text('Error loading tutorials:\n$_error'));
    }

    if (_tutorials.isEmpty) {
      return const Center(child: Text('No tutorials found.'));
    }

    return RefreshIndicator(
      onRefresh: _fetchTutorials,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: _tutorials.length,
        itemBuilder: (context, index) {
          return TutorialCard(tutorial: _tutorials[index]);
        },
      ),
    );
  }
}
