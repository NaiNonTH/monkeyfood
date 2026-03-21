import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkeyfood/cubit/join_restaurant_cubit.dart';
import 'package:monkeyfood/states/join_restaurant_state.dart';

class CreateRestaurantPage extends StatefulWidget {
  const CreateRestaurantPage({super.key});

  @override
  State<CreateRestaurantPage> createState() => _CreateRestaurantPageState();
}

class _CreateRestaurantPageState extends State<CreateRestaurantPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Restaurant')),
      body: BlocConsumer<JoinRestaurantCubit, JoinRestaurantState>(
        listener: (context, joinRestaurantState) {
          if (joinRestaurantState is RestaurantJoined) {
            context.go('/profile');
          }
        },
        builder: (context, joinRestaurantState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField('Restaurant Name', _nameController, (
                        value,
                      ) {
                        if (value.isEmpty) {
                          return "Restaurant Name can't be empty.";
                        }

                        return null;
                      }),
                      SizedBox(height: 16.0),
                      _buildTextField('Location', _locationController, (value) {
                        if (value.isEmpty) return "Location can't be empty.";

                        return null;
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: (joinRestaurantState is JoiningRestaurant)
                      ? () {}
                      : () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<JoinRestaurantCubit>()
                                .createRestaurant(
                                  name: _nameController.text,
                                  location: _locationController.text,
                                );
                          }
                        },
                  child: (joinRestaurantState is JoiningRestaurant)
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create'),
                ),
              ],
            ),
          );
        },
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
