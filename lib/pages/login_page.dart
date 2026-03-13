import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monkeyfood/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              const Color.fromARGB(255, 255, 238, 215),
              const Color.fromARGB(255, 255, 231, 194),
            ],
            stops: [0.8, 0.8],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 160),
              Image.asset('assets/images/logo.png', width: 140, height: 140),
              Text(
                'MonkeyFood',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
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
                      label: 'E-mail',
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      label: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password must not be blank.';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await supabase.auth.signInWithPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            if (context.mounted) {
                              context.go('/');
                            }
                          } on AuthException catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.message)),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Unknown Error')),
                              );
                            }
                          }
                        }
                      },
                      child: const Text('Log In'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                children: [
                  Text('New here? '),
                  GestureDetector(
                    onTap: () {
                      context.go('/register');
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 96, 0),
                      ),
                    ),
                  ),
                ],
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
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.all(8),
      ),
      validator: validator,
    );
  }
}
