import 'package:flutter_riverpod/flutter_riverpod.dart';

//** dimension provider */
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

//** did provider */
final dimensionDidSelectionNotifierProvider =
    StateNotifierProvider<DimensionDidSelectionNotifier, String>((ref) {
  return DimensionDidSelectionNotifier();
});

class DimensionDidSelectionNotifier extends StateNotifier<String> {
  DimensionDidSelectionNotifier() : super("");

  void selectDimension({required String selectedDimension}) {
    state = selectedDimension;
  }
}

//** aVSb Provider */

final aVSbSelectionNotifierProvider =
    StateNotifierProvider<AvsBSelectionNotifier, String>((ref) {
  return AvsBSelectionNotifier();
});

class AvsBSelectionNotifier extends StateNotifier<String> {
  AvsBSelectionNotifier() : super("");

  void selectDimension({required String aVSb}) {
    state = aVSb;
  }
}
