import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/repositories/rating_repositories.dart';
import 'package:monkeyfood/states/review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final RatingRepositories _ratingRepositories;

  ReviewCubit(this._ratingRepositories) : super(ReviewInit());

  Future<void> getReviews(int foodId) async {
    emit(LoadingReview());

    try {
      final reviews = await _ratingRepositories.getReviews(foodId);

      emit(ReviewLoaded(reviews: reviews));
    } catch (e) {
      emit(ReviewError(message: e.toString()));
    }
  }
}
