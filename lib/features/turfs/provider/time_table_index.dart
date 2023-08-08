import 'package:flutter_riverpod/flutter_riverpod.dart';

final timeTableIndexNotifierProvider =
    NotifierProvider<TimeTableIndexNotifier, int>(TimeTableIndexNotifier.new);

class TimeTableIndexNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void timetableIndex({required int index}) {
    state = index;
  }
}
