import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/review_cubit.dart';
import 'package:monkeyfood/states/review_state.dart';
import 'package:monkeyfood/widgets/show_error.dart';

class ReviewPage extends StatefulWidget {
  final int id;

  const ReviewPage({super.key, required this.id});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewCubit>().getReviews(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ReviewCubit>().getReviews(widget.id);
        },
        child: BlocBuilder<ReviewCubit, ReviewState>(
          builder: (context, reviewState) {
            switch (reviewState) {
              case ReviewLoaded():
                return SingleChildScrollView(
                  child: Column(
                    children: reviewState.reviews
                        .map(
                          (review) => Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              border: BoxBorder.fromLTRB(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Colors.grey[400]!,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.account_circle, size: 48),
                                    SizedBox(width: 4),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          review.displayName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: List.generate(
                                            review.rating,
                                            (_) => Icon(Icons.star, size: 14),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        if (review.comment != null)
                                          Text(review.comment!),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              case ReviewError():
                return ShowError(message: reviewState.message);
              default:
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          MediaQuery.of(context).size.height -
                          kToolbarHeight * 2 -
                          kBottomNavigationBarHeight * 2,
                    ),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
