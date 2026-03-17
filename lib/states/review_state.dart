import 'package:monkeyfood/models/review.dart';

abstract class ReviewState {}

class ReviewInit extends ReviewState {}

class LoadingReview extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<Review> reviews;

  ReviewLoaded({required this.reviews});
}

class ReviewError extends ReviewState {
  final String message;

  ReviewError({required this.message});
}
