// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/foods_cubit.dart';
import 'package:monkeyfood/states/foods_state.dart';
import 'package:monkeyfood/widgets/carousel.dart';
import 'package:monkeyfood/widgets/food_card_grid.dart';
import 'package:monkeyfood/widgets/main_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    context.read<FoodsCubit>().loadFoodEntries();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FoodsCubit>().loadFoodEntries();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Carousel(),
            Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
                right: 4.0,
                bottom: 8.0,
              ),
              child: BlocBuilder<FoodsCubit, FoodsState>(
                builder: (context, foodState) {
                  switch (foodState) {
                    case FoodsLoaded():
                      return FoodCardGrid(foods: foodState.foods);
                    case FoodsError():
                      return Center(
                        child: Text(
                          'Something went wrong: ${foodState.message}',
                        ),
                      );
                    default:
                      return Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 32),
                          child: CircularProgressIndicator(),
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
