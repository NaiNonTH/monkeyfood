import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/food_cubit.dart';
import 'package:monkeyfood/states/food_state.dart';
import 'package:monkeyfood/models/food_entry.dart';
import 'package:monkeyfood/widgets/favorite.dart';

class FoodCard extends StatelessWidget {
  final FoodEntry foodEntry;

  const FoodCard({super.key, required this.foodEntry});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodEntryCubit, FoodEntryState>(
      builder: (context, state) {
        FoodEntry currentEntry = state.foodEntries[foodEntry.id];

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  currentEntry.imageUrl ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(child: Icon(Icons.error_outline)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(currentEntry.title)),
                        FavoriteButton(foodEntry: foodEntry),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '\$${currentEntry.price}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              currentEntry.originalPrice != currentEntry.price
                                  ? '\$${currentEntry.originalPrice}'
                                  : '',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 16.0),
                            SizedBox(width: 4.0),
                            Text(currentEntry.rating.toStringAsFixed(2)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
