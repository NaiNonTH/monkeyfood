import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkeyfood/cubit/manage_menus_cubit.dart';
import 'package:monkeyfood/cubit/view_food_cubit.dart';
import 'package:monkeyfood/models/food_upload.dart';
import 'package:monkeyfood/states/manage_menus_state.dart';
import 'package:monkeyfood/states/view_food_state.dart';

class EditMenuPage extends StatefulWidget {
  final int id;
  final int restaurantId;

  const EditMenuPage({super.key, required this.id, required this.restaurantId});

  @override
  State<EditMenuPage> createState() => _EditMenuPageState();
}

class _EditMenuPageState extends State<EditMenuPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _originalPriceController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    context.read<FoodCubit>().loadFoodById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Menu')),
      body: BlocConsumer<ManageMenusCubit, ManageMenusState>(
        listener: (context, addFoodState) {
          if (addFoodState is MenusModified) {
            context.go(
              '/profile/restaurant/${widget.restaurantId}/manage-menus',
            );
          } else if (addFoodState is ManageMenusError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(addFoodState.message)));
          }
        },
        builder: (context, addFoodState) => BlocConsumer<FoodCubit, FoodState>(
          listener: (context, foodState) {
            switch (foodState) {
              case FoodError():
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/profile/restaurant/manage-menus');
                }
              default:
                return;
            }
          },
          builder: (context, foodState) {
            if (foodState is FoodLoaded) {
              if (!_initialized) {
                _titleController.text = foodState.food.title;
                _descriptionController.text = foodState.food.description;
                _originalPriceController.text = foodState.food.originalPrice
                    .toStringAsFixed(2);
                _priceController.text = foodState.food.price.toStringAsFixed(2);
              }

              _initialized = true;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _titleController,
                        label: 'Title',
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Title can't be empty.";
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Description can't be empty.";
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _originalPriceController,
                              label: 'Original Price',
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return "Original Price can't be empty.";
                                }

                                if (double.parse(value.trim()) <= 0) {
                                  return "Original Price can't be zero.";
                                }

                                if (double.parse(value.trim()) <
                                    double.parse(
                                      _priceController.text.trim(),
                                    )) {
                                  return "Original Price can't be less than Discounted Price.";
                                }

                                return null;
                              },
                              isNumber: true,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _priceController,
                              label: 'Price',
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return "Price can't be empty.";
                                }

                                if (double.parse(value.trim()) <= 0) {
                                  return "Price can't be zero.";
                                }

                                return null;
                              },
                              isNumber: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: (addFoodState is ModifyingMenus)
                            ? () {}
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<ManageMenusCubit>()
                                      .updateFoodDetails(
                                        widget.id,
                                        FoodEdit(
                                          title: _titleController.text,
                                          description:
                                              _descriptionController.text,
                                          price: double.parse(
                                            _priceController.text,
                                          ),
                                          originalPrice: double.parse(
                                            _originalPriceController.text,
                                          ),
                                        ),
                                      );
                                }
                              },
                        child: (addFoodState is ModifyingMenus)
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Edit'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required FormFieldValidator validator,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber
          ? TextInputType.numberWithOptions(decimal: true)
          : null,
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : null,
      decoration: InputDecoration(filled: true, labelText: label),
      validator: validator,
    );
  }
}
