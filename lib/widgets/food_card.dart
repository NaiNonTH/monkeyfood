import 'package:flutter/material.dart';
import 'package:monkeyfood/models/food.dart';
import 'package:monkeyfood/services/image_service.dart';
import 'package:monkeyfood/widgets/favorite.dart';

class FoodCard extends StatelessWidget {
  final Food food;

  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              FoodImageService.instance.url(food.imageName) ?? '',
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
                    Expanded(child: Text(food.title)),
                    FavoriteButton(food: food),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '\$${food.price}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          food.originalPrice != food.price
                              ? '\$${food.originalPrice}'
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
                        Text(food.rating.toStringAsFixed(2)),
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
  }
}
