import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/models/availibilty.dart';

final availibiltyNotifierProvider =
    NotifierProvider<AvailibiltyNotifier, Availibilty>(AvailibiltyNotifier.new);

class AvailibiltyNotifier extends Notifier<Availibilty> {
  @override
  Availibilty build() {
    return Availibilty(
      timeId: "",
      turfId: "",
      did: "",
      status: "",
      date: Timestamp.fromDate(DateTime(1999)),
      dimension: "",
      oneHalfHourAvailibilty: [],
      oneHourAvailibilty: [],
    );
  }

  void selectTime({required Availibilty selectedTime}) {
    state = selectedTime;
  }
}
