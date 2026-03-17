import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/search_cubit.dart';
import 'package:monkeyfood/states/search_state.dart';
import 'package:monkeyfood/widgets/food_card_grid.dart';
import 'package:monkeyfood/widgets/show_error.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: SearchBar(
            elevation: WidgetStatePropertyAll(0.0),
            hintText: 'Search Foods...',
            onSubmitted: (value) {
              final query = value.trim();

              if (query.isEmpty) return;

              context.read<SearchCubit>().searchFoodEntries(query);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.of(context).size.height -
                kToolbarHeight * 2 -
                kBottomNavigationBarHeight * 2,
          ),
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, searchState) {
              switch (searchState) {
                case Searched():
                  return FoodCardGrid(foods: searchState.results);
                case SearchInit():
                  return Text('');
                case SearchError():
                  return ShowError(message: searchState.message);
                default:
                  return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
