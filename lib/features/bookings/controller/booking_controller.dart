// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/common/colors.dart';

import 'package:turf_tracker/common/custom_snackbar.dart';
import 'package:turf_tracker/features/bookings/repository/booking_repository.dart';
import 'package:turf_tracker/features/turfs/controller/turf_controller.dart';

import '../../../models/booking.dart';

final bookingControllerProvider =
    StateNotifierProvider<BookingController, bool>((ref) {
  return BookingController(
      bookingRepository: ref.watch(bookingRepositoryProvider), ref: ref);
});

class BookingController extends StateNotifier<bool> {
  final BookingRepository bookingRepository;
  final Ref ref;
  BookingController({
    required this.bookingRepository,
    required this.ref,
  }) : super(false);

  void saveBookingDataToFirestore(
      {required Booking bookingModel, required BuildContext context}) async {
    state = true;
    final res = await bookingRepository.saveBookingDataToFirestore(
        bookingModel: bookingModel);
    state = false;
    res.fold(
      (l) => showSnackbar(context: context, text: l.message),
      (r) {
        increaseBookingCount(context: context);
        showSnackbar(
            context: context, text: "Booked Successfully", color: greenColor);
      },
    );
  }

  //** updating booking number count of an user (for review purposes) */
  void increaseBookingCount({
    required BuildContext context,
  }) async {
    final res = await bookingRepository.increaseBookingCount(
        uid: FirebaseAuth.instance.currentUser!.uid);

    res.fold(
        (l) => showSnackbar(context: context, text: l.message), (r) => null);
  }
}
