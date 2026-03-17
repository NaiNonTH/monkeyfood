import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/add_rating_cubit.dart';
import 'package:monkeyfood/cubit/rating_cubit.dart';
import 'package:monkeyfood/pages/profile/rating_page.dart';
import 'package:monkeyfood/services/image_service.dart';
import 'package:monkeyfood/states/add_rating_state.dart';
import 'package:monkeyfood/states/rating_state.dart';
import 'package:monkeyfood/widgets/scroll_provider.dart';
import 'package:monkeyfood/widgets/show_error.dart';

class ToRatePage extends StatefulWidget {
  const ToRatePage({super.key});

  @override
  State<ToRatePage> createState() => _ToRatePageState();
}

class _ToRatePageState extends State<ToRatePage> {
  @override
  void initState() {
    super.initState();
    context.read<RatingCubit>().getFoodsToRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foods to Rate')),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<RatingCubit>().refreshFoodsToRate();
        },
        child: BlocListener<AddRatingCubit, AddRatingState>(
          listener: (context, addRatingState) {
            if (addRatingState is AddedRating) {
              context.read<RatingCubit>().refreshFoodsToRate();
            }
          },
          child: BlocBuilder<RatingCubit, RatingState>(
            builder: (context, ratingState) {
              switch (ratingState) {
                case RatingLoaded():
                  if (ratingState.foods.isEmpty) {
                    return ScrollProvider(
                      child: Center(child: const Text('No food to rate!')),
                    );
                  }

                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemCount: ratingState.foods.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: SizedBox(
                        width: 100,
                        height: 72,
                        child: Image.network(
                          FoodImageService.instance.url(
                                ratingState.foods[index].imageName,
                              ) ??
                              '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Center(child: Icon(Icons.error_outline)),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        ratingState.foods[index].title,
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: const Icon(Icons.arrow_forward_ios, size: 14),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RatingPage(
                              foodId: ratingState.foods[index].id,
                              foodTitle: ratingState.foods[index].title,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                case RatingError():
                  return ShowError(message: ratingState.message);
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
