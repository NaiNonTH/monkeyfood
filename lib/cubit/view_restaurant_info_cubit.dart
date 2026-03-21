import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/repositories/profile_repositories.dart';
import 'package:monkeyfood/states/view_restaurant_info_state.dart';

class RestaurantInfoCubit extends Cubit<RestaurantInfoState> {
  final ProfileRepositories _profileRepositories;

  RestaurantInfoCubit(this._profileRepositories) : super(RestaurantInfoInit());

  Future<void> loadRestaurantInfo(int restaurantId) async {
    emit(LoadingRestaurantInfo());

    try {
      final restaurant = await _profileRepositories.getRestaurantInfo(
        restaurantId,
      );

      emit(RestaurantInfoLoaded(restaurant: restaurant));
    } catch (e) {
      emit(RestaurantInfoError(message: e.toString()));
    }
  }
}
