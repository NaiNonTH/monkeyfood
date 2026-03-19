import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkeyfood/config.dart';
import 'package:monkeyfood/cubit/update_profile_cubit.dart';
import 'package:monkeyfood/states/update_profile_state.dart';
import 'package:monkeyfood/widgets/main_app_bar.dart';
import 'package:monkeyfood/widgets/show_error.dart';
import 'package:monkeyfood/cubit/view_profile_cubit.dart';
import 'package:monkeyfood/services/supabase_service.dart';
import 'package:monkeyfood/states/view_profile_state.dart';

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
    return Scaffold(
      appBar: GlobalAppBar(),
      body: BlocListener<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, updateProfileState) {
          if (updateProfileState is ProfileUpdated) {
            context.read<ProfileCubit>().getUserProfile();
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
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
                            Expanded(
                              child: Padding(
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
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                context.push('/profile/track-my-order');
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
                                  Icon(Icons.local_shipping_outlined, size: 32),
                                  SizedBox(height: 4),
                                  Text('Track My Order'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                context.push('/profile/to-rate');
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
                                context.push('/profile/favorite');
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
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            title: const Text('Edit Account Info'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                            onTap: () {
                              context.push('/profile/edit-account-info');
                            },
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: const Text('Sign Out'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                            onTap: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  icon: Icon(Icons.warning),
                                  title: const Text(
                                    'Sign Out?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: const Text(
                                    'Are you sure to log out? You will need to log in again next time you use the app.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Log Out'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorScheme.primary,
                                        foregroundColor: colorScheme.onPrimary,
                                      ),
                                      child: const Text('Stay Signed In'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                await supabase.auth.signOut();

                                if (context.mounted) {
                                  context.go('/login');
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                // context.push('/profile/track-my-order');
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
                                  Icon(Icons.assignment, size: 32),
                                  SizedBox(height: 4),
                                  Text('Incoming Orders'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            title: const Text('Manage Menus'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                            onTap: () {
                              context.push('/profile/restaurant/manage-menus');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              case ProfileError():
                return ShowError(message: profileState.message);
              default:
                return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
