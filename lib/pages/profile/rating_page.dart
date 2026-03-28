import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/rate_cubit.dart';
import 'package:monkeyfood/states/add_rating_state.dart';

class RatingPage extends StatefulWidget {
  final int foodId;
  final String foodTitle;

  const RatingPage({super.key, required this.foodId, required this.foodTitle});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int? _ratingScore;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("You're rating"),
            Text(
              widget.foodTitle,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                RadioGroup<int>(
                  groupValue: _ratingScore,
                  onChanged: (int? value) {
                    setState(() {
                      _ratingScore = value;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [Radio<int>(value: 1), const Text('1')]),
                      Column(children: [Radio<int>(value: 2), const Text('2')]),
                      Column(children: [Radio<int>(value: 3), const Text('3')]),
                      Column(children: [Radio<int>(value: 4), const Text('4')]),
                      Column(children: [Radio<int>(value: 5), const Text('5')]),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                TextField(
                  controller: _commentController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Add some comment',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 32),
                BlocConsumer<AddRatingCubit, AddRatingState>(
                  listener: (context, addRatingState) {
                    if (addRatingState is AddRatingError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(addRatingState.message)),
                      );
                    } else if (addRatingState is AddedRating) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.foodTitle} rated!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, addRatingState) => ElevatedButton(
                    onPressed: (addRatingState is AddingRating)
                        ? () {}
                        : () {
                            if (_ratingScore != null) {
                              context.read<AddRatingCubit>().rate(
                                foodId: widget.foodId,
                                ratingScore: _ratingScore!,
                                comment: _commentController.text,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please give a rating score first.',
                                  ),
                                ),
                              );
                            }
                          },
                    child: (addRatingState is AddingRating)
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('Review'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
