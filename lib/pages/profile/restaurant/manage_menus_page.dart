import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkeyfood/config.dart';
import 'package:monkeyfood/cubit/manage_menus_cubit.dart';
import 'package:monkeyfood/models/food.dart';
import 'package:monkeyfood/services/image_service.dart';
import 'package:monkeyfood/states/manage_menus_state.dart';
import 'package:monkeyfood/widgets/line_box.dart';
import 'package:monkeyfood/widgets/scroll_provider.dart';
import 'package:monkeyfood/widgets/show_error.dart';

class ManageMenusPage extends StatefulWidget {
  final int restaurantId;

  const ManageMenusPage({super.key, required this.restaurantId});

  @override
  State<ManageMenusPage> createState() => _ManageMenusPageState();
}

class _ManageMenusPageState extends State<ManageMenusPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ManageMenusCubit>().loadMenus(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Menus')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(
            '/profile/restaurant/${widget.restaurantId}/manage-menus/add',
          );
        },
        child: Icon(Icons.add),
      ),
      body: ScrollProvider(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: SearchBar(
                elevation: WidgetStatePropertyAll(2.0),
                leading: Icon(Icons.search),
                hintText: 'Search Menus...',
                onSubmitted: (value) {
                  context.read<ManageMenusCubit>().searchMenus(
                    widget.restaurantId,
                    value,
                  );
                },
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                trailing: [
                  IconButton(
                    onPressed: () {
                      _searchController.text = '';
                      context.read<ManageMenusCubit>().loadMenus(
                        widget.restaurantId,
                      );
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            BlocConsumer<ManageMenusCubit, ManageMenusState>(
              listener: (context, addFoodState) {
                if (addFoodState is MenusModified) {
                  if (_searchController.text.isEmpty) {
                    context.read<ManageMenusCubit>().loadMenus(
                      widget.restaurantId,
                    );
                  } else {
                    context.read<ManageMenusCubit>().searchMenus(
                      widget.restaurantId,
                      _searchController.text,
                    );
                  }
                }
              },
              builder: (context, addFoodState) {
                switch (addFoodState) {
                  case MenusLoaded():
                    final foods = addFoodState.foods;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      child: Column(
                        children: List<Widget>.generate(foods.length, (index) {
                          final food = foods[index];

                          return LineBox(child: _buildMenu(food));
                        }),
                      ),
                    );
                  case ManageMenusError():
                    return ShowError(message: addFoodState.message);
                  default:
                    return Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                }
              },
            ),
          ],
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
            const SizedBox(width: 8),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              width: 100,
              height: 100,
              child: Image.network(
                FoodImageService.instance.url(food.imageName) ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Center(child: Icon(Icons.error_outline)),
              ),
            ),
            SizedBox(width: 12),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  withData: true,
                );

                if (result != null && context.mounted) {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      icon: Icon(Icons.question_mark),
                      title: const Text('Change Image?'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 96,
                                height: 96,
                                child: Image.network(
                                  FoodImageService.instance.url(
                                        food.imageName,
                                      ) ??
                                      '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(child: Icon(Icons.error_outline)),
                                ),
                              ),
                              Icon(Icons.arrow_right, size: 48),
                              SizedBox(
                                width: 96,
                                height: 96,
                                child: Image.memory(
                                  result.files.single.bytes!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(child: Icon(Icons.error_outline)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Are you sure you want to change the food cover for ${food.title}?',
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          child: const Text('Change'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    context.read<ManageMenusCubit>().updateFoodImage(
                      food.imageName,
                      result.files.single.bytes!,
                    );
                  }
                }
              },
              style: TextButton.styleFrom(padding: EdgeInsets.all(6)),
              child: _buildButtonChild('Change Image', Icons.image),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    context.push(
                      '/profile/restaurant/${widget.restaurantId}/manage-menus/edit/${food.id}',
                    );
                  },
                  child: _buildButtonChild('Edit Food Details', Icons.edit),
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

                    if (confirmed == true && context.mounted) {
                      await context.read<ManageMenusCubit>().deleteFood(
                        food.id,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text('Item Deleted')),
                      );
                    }
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: _buildButtonChild('Delete', Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonChild(String label, IconData icon) {
    return Row(children: [Icon(icon), const SizedBox(width: 4), Text(label)]);
  }
}
