import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/repositories/rating_repositories.dart';
import 'package:monkeyfood/states/rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final RatingRepositories _ratingRepositories;

  RatingCubit(this._ratingRepositories) : super(RatingInit());

  Future<void> getFoodsToRate() async {
    emit(RatingLoading());

    try {
      final foods = await _ratingRepositories.getFoodsToRate();

      emit(RatingLoaded(foods: foods));
    } catch (e) {
      emit(RatingError(message: e.toString()));
    }
  }

  Future<void> refreshFoodsToRate() async {
    final current = state;

    if (current is RatingLoaded) {
      emit(RatingLoaded(foods: current.foods, isRefreshing: true));
    }

    try {
      final foods = await _ratingRepositories.getFoodsToRate();

      emit(RatingLoaded(foods: foods));
    } catch (e) {
      emit(RatingError(message: e.toString()));
    }
  }
}
