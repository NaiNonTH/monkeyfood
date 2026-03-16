abstract class AddRatingState {}

class AddRatingInit extends AddRatingState {}

class AddingRating extends AddRatingState {}

class AddedRating extends AddRatingState {}

class AddRatingError extends AddRatingState {
  final String message;

  AddRatingError({required this.message});
}
