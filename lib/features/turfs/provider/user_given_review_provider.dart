import 'package:flutter_riverpod/flutter_riverpod.dart';

final userGivenRatingNotifierProvider =
    NotifierProvider<UserGivenRatingNotifier, double>(
        UserGivenRatingNotifier.new);

class UserGivenRatingNotifier extends Notifier<double> {
  @override
  build() {
    return 1;
  }

  void giveRating({required double givenRating}) {
    state = givenRating;
  }
}
