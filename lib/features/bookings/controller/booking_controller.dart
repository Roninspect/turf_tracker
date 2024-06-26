// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/common/custom_snackbar.dart';
import 'package:turf_tracker/features/bookings/repository/booking_repository.dart';
import 'package:turf_tracker/models/room.dart';
import '../../../models/booking.dart';

final bookingControllerProvider =
    StateNotifierProvider<BookingController, bool>((ref) {
  return BookingController(
      bookingRepository: ref.watch(bookingRepositoryProvider), ref: ref);
});

final isSharedAlreadyProvider =
    StreamProvider.family<List<Room>, String>((ref, bookingId) {
  return ref
      .watch(bookingControllerProvider.notifier)
      .isSharedAlready(bookingId: bookingId);
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

  //** isShared checking */

  Stream<List<Room>> isSharedAlready({required String bookingId}) {
    return bookingRepository.isSharedAlready(bookingId: bookingId);
  }

  //** update turf owners balance after successfull booking */

  Future<void> updateBalance(
      {required String turfId, required num amountAfterCommission}) async {
    final res = await bookingRepository.updateBalance(
        turfId: turfId, amountAfterCommission: amountAfterCommission);

    res.fold((l) {
      if (kDebugMode) {
        print(l);
      }
    }, (r) {
      if (kDebugMode) {
        print("successfully added to balance");
      }
    });
  }
}
