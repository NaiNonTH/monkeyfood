import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/cart_cubit.dart';
import 'package:monkeyfood/cubit/favorite_cubit.dart';
import 'package:monkeyfood/cubit/food_cubit.dart';
import 'package:monkeyfood/cubit/foods_cubit.dart';
import 'package:monkeyfood/pages/cart_page.dart';
import 'package:monkeyfood/pages/favorite_page.dart';
import 'package:monkeyfood/pages/food_page.dart';
import 'package:monkeyfood/pages/home_page.dart';
import 'package:monkeyfood/pages/profile_page.dart';
import 'package:monkeyfood/repositories/cart_repositories.dart';
import 'package:monkeyfood/repositories/favorite_repositories.dart';
import 'package:monkeyfood/repositories/food_repositories.dart';
import 'package:monkeyfood/services/navigation.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FoodCubit(FoodRepositories())),
        BlocProvider(create: (context) => FoodsCubit(FoodRepositories())),
        BlocProvider(create: (context) => CartCubit(CartRepositories())),
        BlocProvider(
          create: (context) => FavoriteCubit(FavoriteRepositories()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => HomePage(),
          '/food': (context) =>
              FoodPage(id: ModalRoute.of(context)?.settings.arguments as int),
          '/cart': (context) => CartPage(),
          '/profile': (context) => ProfilePage(),
          '/favorite': (context) => FavoritePage(),
        },
        initialRoute: '/',
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        ),
      ),
    );
  }
}
