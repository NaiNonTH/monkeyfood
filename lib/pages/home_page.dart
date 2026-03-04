import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/food_cubit.dart';
import 'package:monkeyfood/widgets/carousel.dart';
import 'package:monkeyfood/widgets/food_card_grid.dart';
import 'package:monkeyfood/widgets/main_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<FoodEntryCubit>().loadFoodEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Carousel(),
            Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
                right: 4.0,
                bottom: 8.0,
              ),
              child: FoodCardGrid(),
            ),
          ],
        ),
      ),
    );
  }
}
