import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/models/availibilty.dart';

final selectedTimeTableNotifierProvider =
    NotifierProvider<SelectedTimeTableNotifier, TimeTable?>(
        SelectedTimeTableNotifier.new);

class SelectedTimeTableNotifier extends Notifier<TimeTable?> {
  @override
  build() {
    return null;
  }

  void selectTimetable({required TimeTable timeTable}) {
    state = timeTable;
  }
}
