import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:monkeyfood/cubit/cart_cubit.dart';
import 'package:monkeyfood/cubit/favorite_cubit.dart';
import 'package:monkeyfood/cubit/food_cubit.dart';
import 'package:monkeyfood/cubit/foods_cubit.dart';
import 'package:monkeyfood/cubit/profile_cubit.dart';
import 'package:monkeyfood/pages/cart_page.dart';
import 'package:monkeyfood/pages/favorite_page.dart';
import 'package:monkeyfood/pages/food_page.dart';
import 'package:monkeyfood/pages/home_page.dart';
import 'package:monkeyfood/pages/login_page.dart';
import 'package:monkeyfood/pages/profile_page.dart';
import 'package:monkeyfood/pages/register_page.dart';
import 'package:monkeyfood/repositories/cart_repositories.dart';
import 'package:monkeyfood/repositories/favorite_repositories.dart';
import 'package:monkeyfood/repositories/food_repositories.dart';
import 'package:monkeyfood/repositories/profile_repositories.dart';
import 'package:monkeyfood/services/supabase_service.dart';
import 'package:monkeyfood/widgets/scaffold.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );

  runApp(const MainApp());
}

class SupabaseAuthNotifier extends ChangeNotifier {
  SupabaseAuthNotifier() {
    supabase.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }
}

final _authNotifier = SupabaseAuthNotifier();

final _router = GoRouter(
  initialLocation: '/home',
  refreshListenable: _authNotifier,
  redirect: (context, state) {
    final isLoggedIn = supabase.auth.currentSession != null;
    final isOnAuth = ['/login', '/register'].contains(state.matchedLocation);

    if (!isLoggedIn && !isOnAuth) return '/login';

    if (isLoggedIn && isOnAuth) return '/home';

    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) => SharedScaffold(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, _) => HomePage()),
        GoRoute(
          path: '/food/:id',
          builder: (_, state) =>
              FoodPage(id: int.parse(state.pathParameters['id']!)),
        ),
        GoRoute(path: '/cart', builder: (_, _) => CartPage()),
        GoRoute(path: '/profile', builder: (_, _) => ProfilePage()),
        GoRoute(path: '/favorite', builder: (_, _) => FavoritePage()),
      ],
    ),
    GoRoute(path: '/login', builder: (_, _) => LoginPage()),
    GoRoute(path: '/register', builder: (_, _) => RegisterPage()),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileCubit(ProfileRepositories())),
        BlocProvider(create: (context) => FoodCubit(FoodRepositories())),
        BlocProvider(create: (context) => FoodsCubit(FoodRepositories())),
        BlocProvider(create: (context) => CartCubit(CartRepositories())),
        BlocProvider(
          create: (context) => FavoriteCubit(FavoriteRepositories()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}
