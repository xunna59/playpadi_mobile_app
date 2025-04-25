import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/tutorial_controller.dart';
import '../models/youtube_tutorials_model.dart';

/// 1) Service instance
final tutorialServiceProvider = Provider((ref) => TutorialService());

/// 2) Async list of tutorials
final tutorialsProvider = FutureProvider<List<TutorialModel>>((ref) {
  final service = ref.read(tutorialServiceProvider);
  return service.fetchTutorials();
});
