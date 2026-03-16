import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkeyfood/cubit/profile_cubit.dart';
import 'package:monkeyfood/cubit/update_profile_cubit.dart';
import 'package:monkeyfood/models/profile.dart';
import 'package:monkeyfood/states/profile_state.dart';
import 'package:monkeyfood/states/update_profile_state.dart';

class EditAccountInfoPage extends StatefulWidget {
  const EditAccountInfoPage({super.key});

  @override
  State<EditAccountInfoPage> createState() => _EditAccountInfoPageState();
}

class _EditAccountInfoPageState extends State<EditAccountInfoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Your Info')),
      body: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, updateProfileState) {
          if (updateProfileState is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('Updated profile successfully!')),
            );
            context.go('/profile');
          } else if (updateProfileState is UpdateProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(updateProfileState.message)));
          }
        },
        builder: (context, updateProfileState) =>
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, profileState) {
                if (profileState is ProfileLoaded) {
                  _displayNameController.text = profileState.user.displayName;
                  _phoneController.text = profileState.user.tel;
                  _locationController.text = profileState.user.location;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                label: 'Display Name',
                                controller: _displayNameController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Display Name can't be empty";
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 16.0),
                              _buildTextField(
                                label: 'Phone Number',
                                controller: _phoneController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Phone Number can't be empty";
                                  }

                                  if (value.length != 10) {
                                    return "Phone Number must contain 10 numbers";
                                  }

                                  if (value[0] != '0') {
                                    return "Phone Number must start with 0";
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 16.0),
                              _buildTextField(
                                label: 'Location',
                                controller: _locationController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Location can't be empty";
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: (updateProfileState is UpdatingProfile)
                              ? () {}
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<UpdateProfileCubit>()
                                        .updateUserProfile(
                                          Profile(
                                            displayName:
                                                _displayNameController.text,
                                            tel: _phoneController.text,
                                            location: _locationController.text,
                                          ),
                                        );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: const Text('nuyh')),
                                    );
                                  }
                                },
                          child: (updateProfileState is UpdatingProfile)
                              ? Center(child: CircularProgressIndicator())
                              : const Text('Submit Profile Edits'),
                        ),
                      ],
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
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(filled: true, labelText: label),
      validator: validator,
    );
  }
}
