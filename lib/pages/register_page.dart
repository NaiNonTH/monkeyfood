import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your E-mail';
                      }

                      final RegExp emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        caseSensitive: false,
                      );

                      if (!emailRegex.hasMatch(value)) {
                        return 'This is not a valid E-mail.';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'E-mail',
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _displayNameController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Display Name',
                    ),
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Display Name must not be blank';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Phone',
                    ),
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Telephone Number must not be blank';
                      }

                      final RegExp phoneRegex = RegExp(r'\d{10}');

                      if (!phoneRegex.hasMatch(value)) {
                        return 'Telephone Number must be 10 numbers';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Password must not be blank';
                      }

                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long.';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Confirm Password',
                    ),
                    validator: (value) {
                      if (_confirmPasswordController.text !=
                          _passwordController.text) {
                        return 'Passwords do not match.';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await Supabase.instance.client.auth.signUp(
                            email: _emailController.text,
                            password: _passwordController.text,
                            data: {
                              'display_name': _displayNameController.text,
                              'tel': _phoneController.text,
                            },
                          );

                          if (context.mounted) {
                            context.go('/home');
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: const Text('ERROR')),
                            );
                          }
                        }
                      }
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Wrap(
              children: [
                Text('Already have an account? '),
                GestureDetector(
                  onTap: () {
                    context.go('/login');
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 204, 122, 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
