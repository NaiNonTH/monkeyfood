import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/favorite_cubit.dart';
import 'package:monkeyfood/models/food_entry.dart';
import 'package:monkeyfood/states/favorite_state.dart';

class FavoriteButton extends StatelessWidget {
  final FoodEntry foodEntry;

  const FavoriteButton({super.key, required this.foodEntry});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        final isFavorite = state.favoriteItems.contains(foodEntry);

        return GestureDetector(
          onTap: () {
            final cubit = context.read<FavoriteCubit>();

            if (isFavorite) {
              cubit.removeFavoriteItem(foodEntry);
            } else {
              cubit.addFavoriteItem(foodEntry);
            }
          },
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
        );
      },
    );
  }
}
