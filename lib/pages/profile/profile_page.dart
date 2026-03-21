import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monkeyfood/config.dart';
import 'package:monkeyfood/cubit/join_restaurant_cubit.dart';
import 'package:monkeyfood/cubit/update_profile_cubit.dart';
import 'package:monkeyfood/states/join_restaurant_state.dart';
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
  final TextEditingController _joinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().getUserProfile();
    });
  }

  @override
  void dispose() {
    _joinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<JoinRestaurantCubit, JoinRestaurantState>(
            listener: (context, joinRestaurantState) {
              if (joinRestaurantState is RestaurantJoined) {
                context.read<ProfileCubit>().getUserProfile();
              } else if (joinRestaurantState is JoinRestaurantError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(joinRestaurantState.message)),
                );
              }
            },
          ),
          BlocListener<UpdateProfileCubit, UpdateProfileState>(
            listener: (context, updateProfileState) {
              if (updateProfileState is ProfileUpdated) {
                context.read<ProfileCubit>().getUserProfile();
              } else if (updateProfileState is UpdateProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(updateProfileState.message)),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            switch (profileState) {
              case ProfileLoaded():
                debugPrint(profileState.user.restaurant.toString());
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
                          _buildBigIconButton(
                            'Track My Order',
                            Icons.local_shipping_outlined,
                            '/profile/track-my-order',
                          ),
                          _buildBigIconButton(
                            'To Rate',
                            Icons.star_outline,
                            '/profile/to-rate',
                          ),
                          _buildBigIconButton(
                            'Favorites',
                            Icons.favorite_outline,
                            '/profile/favorite',
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
                      if (profileState.user.restaurant != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                _buildBigIconButton(
                                  'Incoming Orders',
                                  Icons.assignment,
                                  '/profile/restaurant/${profileState.user.restaurant!.id}/incoming-orders',
                                ),
                                _buildBigIconButton(
                                  'Delivering',
                                  Icons.local_shipping,
                                  '/profile/restaurant/${profileState.user.restaurant!.id}/delivering',
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
                                'Restaurant Settings (${profileState.user.restaurant!.name})',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                ListTile(
                                  title: const Text('Invite'),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                  ),
                                  onTap: () async {
                                    await _showRestaurantCode(profileState);
                                  },
                                ),
                                Divider(height: 1),
                                ListTile(
                                  title: const Text('Manage Menus'),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                  ),
                                  onTap: () {
                                    context.push(
                                      '/profile/restaurant/${profileState.user.restaurant!.id}/manage-menus',
                                    );
                                  },
                                ),
                                Divider(height: 1),
                                ListTile(
                                  title: const Text('Leave Restaurant'),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                  ),
                                  onTap: _handleLeaveRestaurant,
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (profileState.user.restaurant == null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: SizedBox(
                              width: 280,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      'Want to start a business?',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorScheme.primary,
                                      foregroundColor: colorScheme.onPrimary,
                                    ),
                                    onPressed: _handleJoinRestaurant,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.group_add),
                                        SizedBox(width: 8),
                                        const Text('Join Existing Restaurant'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Text(
                                        'or',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                    ),
                                    onPressed: () {
                                      context.push(
                                        '/profile/create-restaurant',
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add),
                                        SizedBox(width: 8),
                                        const Text('Create New One'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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

  Widget _buildBigIconButton(String label, IconData iconData, String location) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          context.push(location);
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.zero),
          ),
        ),
        child: Column(
          children: [
            Icon(iconData, size: 32),
            SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }

  Future<void> _handleJoinRestaurant() async {
    final joinCode = await showDialog<String?>(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter Join Code',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _joinCodeController,
                decoration: InputDecoration(
                  labelText: 'Join Code',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pop(_joinCodeController.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: const Text('Join'),
                  ),
                  SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (joinCode != null && joinCode.isNotEmpty && context.mounted) {
      context.read<JoinRestaurantCubit>().joinRestaurant(joinCode);
    }
  }

  Future<void> _handleLeaveRestaurant() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.logout),
        title: const Text('Leave Restaurant'),
        content: const Text(
          'Are you sure to leave restaurant? You will not be able to interact with your restaurant until you join it again.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Leave'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<JoinRestaurantCubit>().leaveRestaurant();
    }
  }

  Future<void> _showRestaurantCode(ProfileLoaded profileState) async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'The following is the Join Code for ${profileState.user.restaurant!.name}',
              ),
              SizedBox(height: 16.0),
              Text(
                profileState.user.restaurant!.joinCode,
                style: TextStyle(
                  fontSize: 28,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Send this code to your employees to enter in Join Restaurant menu to invite them into your restaurant.',
              ),
              SizedBox(height: 24.0),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
