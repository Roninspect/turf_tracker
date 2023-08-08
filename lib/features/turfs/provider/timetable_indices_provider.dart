import 'package:flutter_riverpod/flutter_riverpod.dart';

final timeTableIndicesNotifierProvider =
    NotifierProvider<ListOfTimeTableIndicesNotifier, int>(
        ListOfTimeTableIndicesNotifier.new);

class ListOfTimeTableIndicesNotifier extends Notifier<int> {
  @override
  build() {
    return 0;
  }

  void selectListOfTimetableIndices({required int index}) {
    state = index;
  }
}
