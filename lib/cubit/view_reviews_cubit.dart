import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/repositories/rating_repositories.dart';
import 'package:monkeyfood/states/view_reviews_state.dart';

class ReviewCubit extends Cubit<ReviewsState> {
  final RatingRepositories _ratingRepositories;

  ReviewCubit(this._ratingRepositories) : super(ReviewsInit());

  Future<void> getReviews(int foodId) async {
    emit(LoadingReviews());

    try {
      final reviews = await _ratingRepositories.getReviews(foodId);

      emit(ReviewsLoaded(reviews: reviews));
    } catch (e) {
      emit(ReviewsError(message: e.toString()));
    }
  }

  Future<void> refreshReviews(int foodId) async {
    final current = state;

    if (current is ReviewsLoaded) {
      emit(ReviewsLoaded(reviews: current.reviews, isRefreshing: true));
    }

    try {
      final reviews = await _ratingRepositories.getReviews(foodId);

      emit(ReviewsLoaded(reviews: reviews));
    } catch (e) {
      emit(ReviewsError(message: e.toString()));
    }
  }
}
