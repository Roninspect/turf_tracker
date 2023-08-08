import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/models/availibilty.dart';

final selectedTimeTableNotifierProvider =
    NotifierProvider<SelectedTimeTableNotifier, TimeTable>(
        SelectedTimeTableNotifier.new);

class SelectedTimeTableNotifier extends Notifier<TimeTable> {
  @override
  build() {
    return TimeTable(
        isAvailable: true,
        isLocked: true,
        price: 0,
        startTime: Timestamp(0, 0),
        endTime: Timestamp(0, 0));
  }

  void selectTimetable({required TimeTable timeTable}) {
    state = timeTable;
  }
}
