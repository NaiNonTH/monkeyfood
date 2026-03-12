import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', Supabase.instance.client.auth.currentUser!.id)
          .single(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Column(
            children: [
              Text('Something went wrong: ${snapshot.error}'),
              ListTile(
                title: const Text('Sign Out'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () async {
                  await Supabase.instance.client.auth.signOut();

                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              ),
            ],
          );
        }

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
                            snapshot.data!['display_name'],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(snapshot.data!['location']),
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
                          borderRadius: BorderRadiusGeometry.all(Radius.zero),
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
                          borderRadius: BorderRadiusGeometry.all(Radius.zero),
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
                          borderRadius: BorderRadiusGeometry.all(Radius.zero),
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
                      await Supabase.instance.client.auth.signOut();

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
                          borderRadius: BorderRadiusGeometry.all(Radius.zero),
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
      },
    );
  }
}
