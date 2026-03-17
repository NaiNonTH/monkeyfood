import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Menu')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                onPressed: () {
                  print(_formKey.currentState!.validate());
                },
                child: const Text('Add'),
              ),
            ],
          ),
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
