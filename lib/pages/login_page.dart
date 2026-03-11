import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 160),
            Icon(Icons.delivery_dining, size: 96),
            Text(
              'MonkeyFood',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 48),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter your E-mail';

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
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(height: 24),
                  FilledButton(
                    onPressed: () async {
                      try {
                        await Supabase.instance.client.auth.signInWithPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        if (context.mounted) {
                          context.go('/home');
                        }
                      } on AuthException catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.message)));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Unknown Error')),
                          );
                        }
                      }
                    },
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
