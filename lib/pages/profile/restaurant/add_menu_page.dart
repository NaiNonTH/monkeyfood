import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:humanize/humanize.dart';
import 'package:monkeyfood/cubit/add_food_cubit.dart';
import 'package:monkeyfood/models/food_upload.dart';
import 'package:monkeyfood/models/img_upload.dart';
import 'package:monkeyfood/states/add_food_state.dart';

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({super.key});

  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _originalPriceController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  ImgUpload? upload;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _originalPriceController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Menu')),
      body: BlocConsumer<AddFoodCubit, AddFoodState>(
        listener: (context, addFoodstate) {
          if (addFoodstate is FoodAdded) {
            context.go('/profile/restaurant/manage-menus');

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: const Text('Food Uploaded')));
          } else if (addFoodstate is AddFoodError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${addFoodstate.message}')),
            );
          }
        },
        builder: (context, addFoodstate) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (upload == null)
                    ElevatedButton(
                      onPressed: () async {
                        await _handleFileUpload();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(16.0),
                        ),
                      ),
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 32),
                            const Text('Upload Image'),
                          ],
                        ),
                      ),
                    ),
                  if (upload != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 240,
                          height: 240,
                          child: Image.memory(
                            upload!.bytes!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(child: Icon(Icons.error_outline)),
                          ),
                        ),
                        SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(upload!.name),
                                  Text(
                                    filesizeformat(upload!.size),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            TextButton(
                              onPressed: () async {
                                await _handleFileUpload();
                              },
                              child: const Text('Edit Image'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _titleController,
                    label: 'Title',
                    validator: (value) {
                      if (value.trim().isEmpty) return "Title can't be empty.";

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
                                double.parse(_priceController.text.trim())) {
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
                    onPressed: (addFoodstate is AddingFood)
                        ? () {}
                        : () {
                            if (_formKey.currentState!.validate()) {
                              if (upload == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Please upload your food image.',
                                    ),
                                  ),
                                );

                                return;
                              }

                              context.read<AddFoodCubit>().addFood(
                                FoodUpload(
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                  price: double.parse(_priceController.text),
                                  originalPrice: double.parse(
                                    _originalPriceController.text,
                                  ),
                                  upload: upload!,
                                ),
                              );
                            }
                          },
                    child: (addFoodstate is AddingFood)
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Add'),
                  ),
                ],
              ),
            ),
          );
        },
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

  Future<void> _handleFileUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true, // ensures bytes are loaded
    );

    if (result != null) {
      setState(() {
        upload = ImgUpload(
          bytes: result.files.single.bytes, // use bytes instead of File
          name: result.files.single.name,
          size: result.files.single.size,
        );
      });
    } else {
      debugPrint('File cancelled');
    }
  }
}
