import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/feedback/data/feedback_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  return FeedbackRepository(ref.read(apiClientProvider));
});
