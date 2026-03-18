import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkeyfood/config.dart';
import 'package:monkeyfood/cubit/add_food_cubit.dart';
import 'package:monkeyfood/cubit/foods_cubit.dart';
import 'package:monkeyfood/models/food.dart';
import 'package:monkeyfood/services/image_service.dart';
import 'package:monkeyfood/states/add_food_state.dart';
import 'package:monkeyfood/states/foods_state.dart';
import 'package:monkeyfood/widgets/line_box.dart';
import 'package:monkeyfood/widgets/show_error.dart';

class ManageMenusPage extends StatefulWidget {
  const ManageMenusPage({super.key});

  @override
  State<ManageMenusPage> createState() => _ManageMenusPageState();
}

class _ManageMenusPageState extends State<ManageMenusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Menus')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/profile/restaurant/manage-menus/add');
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: BlocListener<AddFoodCubit, AddFoodState>(
          listener: (context, addFoodState) {
            if (addFoodState is FoodAdded) {
              context.read<FoodsCubit>().loadFoodEntries();
            }
          },
          child: BlocBuilder<FoodsCubit, FoodsState>(
            builder: (context, foodsState) {
              switch (foodsState) {
                case FoodsLoaded():
                  final foods = foodsState.foods;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: Column(
                      children: List<Widget>.generate(foodsState.foods.length, (
                        index,
                      ) {
                        final food = foods[index];

                        return LineBox(child: _buildMenu(food));
                      }),
                    ),
                  );
                case FoodsError():
                  return ShowError(message: foodsState.message);
                default:
                  return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(Food food) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                FoodImageService.instance.url(food.imageName) ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Center(child: Icon(Icons.error_outline)),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    food.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                context.push(
                  '/profile/restaurant/manage-menus/edit/${food.id}',
                );
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: Icon(Icons.warning),
                    title: Text('Delete Item?'),
                    content: Text(
                      'Are you sure you want to delete ${food.title}?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Delete'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: const Text('Item Deleted')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text('Cancel Delete')),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }
}
