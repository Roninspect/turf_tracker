import 'package:flutter_riverpod/flutter_riverpod.dart';

final sportsSelectionNotifierProvider =
    StateNotifierProvider<SportsSelectionNotifier, int>((ref) {
  return SportsSelectionNotifier();
});

class SportsSelectionNotifier extends StateNotifier<int> {
  SportsSelectionNotifier() : super(0);

  void changeSports({required int selectedSports}) {
    state = selectedSports;
  }
}
