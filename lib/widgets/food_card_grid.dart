import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/food_cubit.dart';
import 'package:monkeyfood/states/food_state.dart';
import 'package:monkeyfood/models/food_entry.dart';
import 'package:monkeyfood/widgets/food_card.dart';

class FoodCardGrid extends StatefulWidget {
  const FoodCardGrid({super.key});

  @override
  State<FoodCardGrid> createState() => _FoodCardGridState();
}

class _FoodCardGridState extends State<FoodCardGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodEntryCubit, FoodEntryState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 1.0 / sqrt(2),
        ),
        itemCount: state.foodEntries.length,
        itemBuilder: (context, index) {
          FoodEntry foodEntry = state.foodEntries[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/food', arguments: foodEntry.id);
            },
            child: FoodCard(foodEntry: foodEntry),
          );
        },
      ),
    );
  }
}
