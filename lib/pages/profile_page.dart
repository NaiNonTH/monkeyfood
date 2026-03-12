import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkeyfood/cubit/profile_cubit.dart';
import 'package:monkeyfood/services/supabase_service.dart';
import 'package:monkeyfood/states/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        switch (profileState) {
          case ProfileLoaded():
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.account_circle, size: 96),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileState.user.displayName,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(profileState.user.location),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.zero,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.local_shipping_outlined, size: 32),
                              SizedBox(height: 4),
                              Text('Track My Order'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.zero,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.star_border, size: 32),
                              SizedBox(height: 4),
                              Text('To Rate'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            context.push('/favorite');
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.zero,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.favorite_outline, size: 32),
                              SizedBox(height: 4),
                              Text('Favorite'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      'Account Settings',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: const Text('Edit Account Info'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {},
                      ),
                      Divider(height: 1),
                      ListTile(
                        title: const Text('Edit Location'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {},
                      ),
                      Divider(height: 1),
                      ListTile(
                        title: const Text('Edit Payment Details'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {},
                      ),
                      Divider(height: 1),
                      ListTile(
                        title: const Text('Sign Out'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () async {
                          await supabase.auth.signOut();

                          if (context.mounted) {
                            context.go('/login');
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.zero,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.assignment, size: 32),
                              SizedBox(height: 4),
                              Text('Track My Order'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      'Account Settings',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: const Text('Edit Restaurant Info'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {},
                      ),
                      Divider(height: 1),
                      ListTile(
                        title: const Text('Manage Menus'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            );
          case ProfileError():
            return Column(
              children: [
                Text('Something went wrong: ${profileState.message}'),
                ListTile(
                  title: const Text('Sign Out'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () async {
                    await supabase.auth.signOut();

                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
              ],
            );
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
