import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/repositories/rating_repositories.dart';
import 'package:monkeyfood/states/add_rating_state.dart';

class AddRatingCubit extends Cubit<AddRatingState> {
  final RatingRepositories _ratingRepositories;

  AddRatingCubit(this._ratingRepositories) : super(AddRatingInit());

  Future<void> rate({
    required int foodId,
    required int ratingScore,
    String? comment,
  }) async {
    emit(AddingRating());

    try {
      await _ratingRepositories.rate(
        foodId: foodId,
        ratingScore: ratingScore,
        comment: comment,
      );

      emit(AddedRating());
    } catch (e) {
      emit(AddRatingError(message: e.toString()));
    }
  }
}
