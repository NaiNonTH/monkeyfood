import 'package:monkeyfood/models/review.dart';

abstract class ReviewsState {}

class ReviewsInit extends ReviewsState {}

class LoadingReviews extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<Review> reviews;
  final bool isRefreshing;

  ReviewsLoaded({required this.reviews, this.isRefreshing = false});
}

class ReviewsError extends ReviewsState {
  final String message;

  ReviewsError({required this.message});
}
