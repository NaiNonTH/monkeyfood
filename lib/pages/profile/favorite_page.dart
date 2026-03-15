import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/favorite_cubit.dart';
import 'package:monkeyfood/services/image_service.dart';
import 'package:monkeyfood/states/favorite_state.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(height: 1),
          itemCount: state.favoriteItems.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 72,
                  child: Image.network(
                    FoodImageService.instance.url(
                          state.favoriteItems[index].imageName,
                        ) ??
                        '',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      state.favoriteItems[index].title,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${state.favoriteItems[index].originalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '\$${state.favoriteItems[index].price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          context.read<FavoriteCubit>().removeFavoriteItem(
                            state.favoriteItems[index].id,
                          );
                        },
                        child: Icon(Icons.delete_outline, size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
