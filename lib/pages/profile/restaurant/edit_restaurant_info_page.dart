import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkeyfood/cubit/view_restaurant_info_cubit.dart';
import 'package:monkeyfood/cubit/join_restaurant_cubit.dart';
import 'package:monkeyfood/states/join_restaurant_state.dart';
import 'package:monkeyfood/states/view_restaurant_info_state.dart';

class EditRestaurantInfoPage extends StatefulWidget {
  final int restaurantId;

  const EditRestaurantInfoPage({super.key, required this.restaurantId});

  @override
  State<EditRestaurantInfoPage> createState() => _EditRestaurantInfoPageState();
}

class _EditRestaurantInfoPageState extends State<EditRestaurantInfoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    context.read<RestaurantInfoCubit>().loadRestaurantInfo(widget.restaurantId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Restaurant Info')),
      body: BlocConsumer<JoinRestaurantCubit, JoinRestaurantState>(
        listener: (context, joinRestaurantState) {
          if (joinRestaurantState is RestaurantJoined) {
            context.go('/profile');
          }
        },
        builder: (context, joinRestaurantState) =>
            BlocBuilder<RestaurantInfoCubit, RestaurantInfoState>(
              builder: (context, restaurantInfoState) {
                switch (restaurantInfoState) {
                  case RestaurantInfoLoaded():
                    if (!_isInitialized) {
                      _nameController.text =
                          restaurantInfoState.restaurant.name;
                      _locationController.text =
                          restaurantInfoState.restaurant.location;
                    }

                    _isInitialized = true;

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                  'Restaurant Name',
                                  _nameController,
                                  (value) {
                                    if (value.isEmpty) {
                                      return "Restaurant Name can't be empty.";
                                    }

                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.0),
                                _buildTextField(
                                  'Location',
                                  _locationController,
                                  (value) {
                                    if (value.isEmpty) {
                                      return "Location can't be empty.";
                                    }

                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed:
                                (joinRestaurantState is JoiningRestaurant)
                                ? () {}
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context
                                          .read<JoinRestaurantCubit>()
                                          .updateRestaurant(
                                            widget.restaurantId,
                                            name: _nameController.text,
                                            location: _locationController.text,
                                          );
                                    }
                                  },
                            child: (joinRestaurantState is JoiningRestaurant)
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
                    );
                  default:
                    return Center(child: CircularProgressIndicator());
                }
              },
            ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    FormFieldValidator validator,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, filled: false),
      validator: validator,
    );
  }
}
