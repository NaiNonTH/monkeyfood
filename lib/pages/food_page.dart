import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/cart_cubit.dart';
import 'package:monkeyfood/cubit/food_cubit.dart';
import 'package:monkeyfood/cubit/foods_cubit.dart';
import 'package:monkeyfood/models/cart_item.dart';
import 'package:monkeyfood/states/food_state.dart';
import 'package:monkeyfood/states/foods_state.dart';
import 'package:monkeyfood/widgets/food_card_grid.dart';
import 'package:monkeyfood/widgets/main_app_bar.dart';

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
    return Scaffold(
      appBar: GlobalAppBar(),
      body: BlocBuilder<FoodCubit, FoodState>(
        builder: (context, foodState) {
          switch (foodState) {
            case FoodLoaded():
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      foodState.food.imageUrl ?? '',
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
                              // FavoriteButton(food: foodState.food),
                            ],
                          ),
                          SizedBox(height: 4.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '\$${foodState.food.price}',
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 4.0),
                                  Text(
                                    foodState.food.originalPrice !=
                                            foodState.food.price
                                        ? '\$${foodState.food.originalPrice}'
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
                              onPressed: () {
                                final messenger = ScaffoldMessenger.of(context);

                                context.read<CartCubit>().addCartItem(
                                  CartItem(foodState.food),
                                );

                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Added ${foodState.food.title} to Cart',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Add to Cart'),
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
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
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
                              return Center(child: CircularProgressIndicator());
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
    );
  }
}
