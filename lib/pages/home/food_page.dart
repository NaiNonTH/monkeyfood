import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/add_to_cart_cubit.dart';
import 'package:monkeyfood/cubit/food_cubit.dart';
import 'package:monkeyfood/cubit/foods_cubit.dart';
import 'package:monkeyfood/services/image_service.dart';
import 'package:monkeyfood/states/add_to_cart_state.dart';
import 'package:monkeyfood/states/food_state.dart';
import 'package:monkeyfood/states/foods_state.dart';
import 'package:monkeyfood/widgets/favorite.dart';
import 'package:monkeyfood/widgets/food_card_grid.dart';

class FoodPage extends StatefulWidget {
  final int id;

  const FoodPage({super.key, required this.id});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  @override
  void initState() {
    super.initState();
    context.read<FoodCubit>().loadFoodById(widget.id);
    context.read<FoodsCubit>().loadFoodEntries();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FoodCubit>().loadFoodById(widget.id);
        context.read<FoodsCubit>().loadFoodEntries();
      },
      child: BlocConsumer<AddToCartCubit, AddToCartState>(
        listener: (context, addToCartState) {
          switch (addToCartState) {
            case AddedToCart():
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Item is added to Cart')));
              break;
            case AddToCartError():
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(addToCartState.message)));
              break;
          }
        },
        builder: (context, addToCartState) => BlocBuilder<FoodCubit, FoodState>(
          builder: (context, foodState) {
            switch (foodState) {
              case FoodLoaded():
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.network(
                        FoodImageService.instance.url(
                              foodState.food.imageName,
                            ) ??
                            '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 600,
                        errorBuilder: (context, error, stackTrace) =>
                            Center(child: Icon(Icons.error_outline)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  foodState.food.title,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                FavoriteButton(food: foodState.food),
                              ],
                            ),
                            SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '\$${foodState.food.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      foodState.food.originalPrice !=
                                              foodState.food.price
                                          ? '\$${foodState.food.originalPrice.toStringAsFixed(2)}'
                                          : '',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 20.0,
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      foodState.food.rating.toStringAsFixed(2),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: (addToCartState is AddingToCart)
                                    ? () {}
                                    : () {
                                        context
                                            .read<AddToCartCubit>()
                                            .addCartItem(foodState.food.id);
                                      },
                                child: (addToCartState is AddingToCart)
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Add to Cart'),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              children: [
                                Icon(Icons.account_circle, size: 32.0),
                                SizedBox(width: 8.0),
                                Text(
                                  "Restaurant Name",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              foodState.food.description,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        indent: 4.0,
                        endIndent: 4.0,
                        thickness: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: BlocBuilder<FoodsCubit, FoodsState>(
                          builder: (context, foodsState) {
                            switch (foodsState) {
                              case FoodsLoaded():
                                return FoodCardGrid(foods: foodsState.foods);
                              case FoodsError():
                                return Center(
                                  child: Text(
                                    'Something went wrong: ${foodsState.message}',
                                  ),
                                );
                              default:
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              case FoodError():
                return Center(
                  child: Text('Something went wrong: ${foodState.message}'),
                );
              default:
                return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
