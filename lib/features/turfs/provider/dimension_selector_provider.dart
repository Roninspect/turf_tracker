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
