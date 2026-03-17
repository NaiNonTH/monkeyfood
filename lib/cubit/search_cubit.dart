import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/repositories/food_repositories.dart';
import 'package:monkeyfood/states/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final FoodRepositories _foodRepositories;

  SearchCubit(this._foodRepositories) : super(SearchInit());

  Future<void> searchFoodEntries(String query) async {
    emit(Searching());

    try {
      final results = await _foodRepositories.searchFoodEntries(query);

      emit(Searched(results: results));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  Future<void> resetResults() async {
    emit(SearchInit());
  }
}
