import 'package:flutter_riverpod/flutter_riverpod.dart';

final dimensionSelectionNotifierProvider =
    StateNotifierProvider<DimensionSelectionNotifier, String>((ref) {
  return DimensionSelectionNotifier();
});

class DimensionSelectionNotifier extends StateNotifier<String> {
  DimensionSelectionNotifier() : super("");

  void selectDimension({required String selectedDimension}) {
    state = selectedDimension;
  }
}
