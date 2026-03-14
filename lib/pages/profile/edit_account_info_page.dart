import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/profile_cubit.dart';
import 'package:monkeyfood/states/profile_state.dart';

class EditAccountInfoPage extends StatefulWidget {
  const EditAccountInfoPage({super.key});

  @override
  State<EditAccountInfoPage> createState() => _EditAccountInfoPageState();
}

class _EditAccountInfoPageState extends State<EditAccountInfoPage> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
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
                  child: Column(
                    children: [
                      _buildTextField('Display Name', _displayNameController),
                      SizedBox(height: 16.0),
                      _buildTextField('Phone Number', _phoneController),
                      SizedBox(height: 16.0),
                      _buildTextField('Location', _locationController),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Submit Profile Edits'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(filled: true, labelText: label),
    );
  }
}
