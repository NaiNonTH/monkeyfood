import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkeyfood/models/food.dart';
import 'package:monkeyfood/widgets/food_card.dart';

class FoodCardGrid extends StatefulWidget {
  final List<Food> foods;

  const FoodCardGrid({super.key, required this.foods});

  @override
  State<FoodCardGrid> createState() => _FoodCardGridState();
}

class _FoodCardGridState extends State<FoodCardGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0 / sqrt(2),
      ),
      itemCount: widget.foods.length,
      itemBuilder: (context, index) {
        Food food = widget.foods[index];
        return GestureDetector(
          onTap: () {
            context.push('/food/$index');
          },
          child: FoodCard(food: food),
        );
      },
    );
  }
}
