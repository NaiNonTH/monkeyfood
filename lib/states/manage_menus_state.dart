import 'package:monkeyfood/models/food.dart';

abstract class ManageMenusState {}

class ManageMenusInit extends ManageMenusState {}

class LoadingMenus extends ManageMenusState {}

class MenusLoaded extends ManageMenusState {
  final List<Food> foods;

  MenusLoaded({required this.foods});
}

class ModifyingMenus extends ManageMenusState {}

class MenusModified extends ManageMenusState {}

class ManageMenusError extends ManageMenusState {
  final String message;

  ManageMenusError({required this.message});
}
