// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/common/custom_snackbar.dart';
import 'package:turf_tracker/features/turfs/repository/turf_repository.dart';
import '../../../models/availibilty.dart';
import '../../../models/booking.dart';
import '../../../models/dimensions.dart';
import '../../../models/favorites.dart';
import '../../../models/rating.dart';
import '../../../models/turf.dart';
import '../provider/slot_type_selector_provider.dart';

class ArgsModel {
  final String turfId;
  final String secondParams;

  const ArgsModel({required this.turfId, required this.secondParams});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArgsModel &&
        other.turfId == turfId &&
        other.secondParams == secondParams;
  }

  @override
  int get hashCode => turfId.hashCode ^ secondParams.hashCode;
}

class TripleArgsModel {
  final String turfId;
  final String dimensionId;
  final Timestamp selectedDate;

  const TripleArgsModel({
    required this.turfId,
    required this.dimensionId,
    required this.selectedDate,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TripleArgsModel &&
        other.turfId == turfId &&
        other.dimensionId == dimensionId &&
        other.selectedDate == selectedDate;
  }

  @override
  int get hashCode =>
      turfId.hashCode ^ dimensionId.hashCode ^ selectedDate.hashCode;
}

final turfControllerProvider = Provider<TurfController>((ref) {
  return TurfController(
      turfRepository: ref.watch(turfRepositoryProvider), ref: ref);
});

final fetchTurfByAlreadySelectedDistrictProvider =
    StreamProvider.family<List<Turf>, String>((ref, alreadySelectedDistrict) {
  return ref.watch(turfControllerProvider).fetchTurfByAlreadySelectedDistrict(
      alreadySelectedDistrict: alreadySelectedDistrict);
});

final fetchDimensionsByTurfIdProvider = StreamProvider.family
    .autoDispose<List<Dimensions>, ArgsModel>((ref, vendoCode) {
  return ref.watch(turfControllerProvider).fetchDimensionsByTurfId(
      turfId: vendoCode.turfId, selectedSports: vendoCode.secondParams);
});

final fetchTimeAvailableProvider = StreamProvider.family
    .autoDispose<List<Availibilty>, ArgsModel>((ref, vendoCode) {
  String turfId = vendoCode.turfId;
  String dimensionName = vendoCode.secondParams;
  return ref
      .watch(turfControllerProvider)
      .fetchTimeAvailable(turfId: turfId, dimensionName: dimensionName);
});

final isFavoritedProvider =
    StreamProvider.family.autoDispose<List<Favorite>, String>((ref, turfId) {
  return ref.watch(turfControllerProvider).isFavorited(turfId: turfId);
});

final getTimeAvailibiltiesProvider = StreamProvider.family
    .autoDispose<Availibilty, TripleArgsModel>((ref, vendoCode) {
  return ref.watch(turfControllerProvider).getTimeAvailibilties(
      turfId: vendoCode.turfId,
      dimensionId: vendoCode.dimensionId,
      selectedDate: vendoCode.selectedDate);
});

final getTwoBookingsProvider =
    StreamProvider.family<List<Booking>, String>((ref, turfId) {
  return ref.watch(turfControllerProvider).getTwoBookings(turfId: turfId);
});

class TurfController {
  final TurfRepository _turfRepository;

  TurfController({required TurfRepository turfRepository, required Ref ref})
      : _turfRepository = turfRepository;

  Stream<List<Turf>> fetchTurfByAlreadySelectedDistrict(
      {required String alreadySelectedDistrict}) {
    return _turfRepository.fetchTurfByAlreadySelectedDistrict(
        alreadySelectedDistrict: alreadySelectedDistrict);
  }

  Stream<List<Dimensions>> fetchDimensionsByTurfId(
      {required String turfId, required String selectedSports}) {
    return _turfRepository.fetchDimensionsByTurfId(
        turfId: turfId, selectedSports: selectedSports);
  }

  Stream<List<Availibilty>> fetchTimeAvailable(
      {required String turfId, required String dimensionName}) {
    return _turfRepository.fetchTimeAvailable(
        turfId: turfId, dimensionName: dimensionName);
  }

//   void updateAvailibiltyStatus({
//     required List<int> timetableIndices,
//     required List<TimeTable> updatedTimetables,
//     required BuildContext context,
//     required String timeId,
//   }) async {
//     final res = await _turfRepository.updateAvailibiltyStatus(
//       timetableIndices: timetableIndices,
//       updatedTimetables: updatedTimetables,
//       timeId: timeId,
//     );

//     res.fold((l) => showSnackbar(context: context, text: l.message),
//         (r) => showSnackbar(context: context, text: "Booked Successfully"));
//   }

// //** locking selected Time slots */
//   void lockingSelectedTimeSlot({
//     required List<int> timetableIndices,
//     required List<TimeTable> updatedTimetables,
//     required BuildContext context,
//     required String timeId,
//   }) async {
//     final res = await _turfRepository.lockingselectedtimeslots(
//       timetableIndices: timetableIndices,
//       updatedTimetables: updatedTimetables,
//       timeId: timeId,
//     );

//     res.fold(
//         (l) => showSnackbar(context: context, text: l.message),
//         (r) => showSnackbar(
//             context: context,
//             text:
//                 "Selected Slots are locked for you only, it'll expire in 3 minutes"));
//   }

//   //** unlocking selected Time slots */
//   void unlockingSelectedTimeSlot({
//     required List<int> timetableIndices,
//     required List<TimeTable> updatedTimetables,
//     required BuildContext context,
//     required String timeId,
//   }) async {
//     final res = await _turfRepository.unlockingTimeLots(
//       timetableIndices: timetableIndices,
//       updatedTimetables: updatedTimetables,
//       timeId: timeId,
//     );

//     res.fold(
//         (l) => showSnackbar(context: context, text: l.message), (r) => null);
//   }

  void updateTimeSlotAfterBooking({
    required TimeTable selectedSlot,
    required SlotType slotType,
    required Availibilty selectedAvailibilty,
    required BuildContext context,
  }) async {
    final res = await _turfRepository.updateTimeSlotAfterBooking(
      selectedSlot: selectedSlot,
      slotType: slotType,
      selectedAvailibilty: selectedAvailibilty,
    );

    res.fold(
      (l) => showSnackbar(context: context, text: l.message),
      (r) => showSnackbar(context: context, text: "Successfull"),
    );
  }

  //** favoriting a turf */

  void favoriteATurf({required String turfId}) async {
    _turfRepository.favoriteATurf(
        turfId: turfId, uid: FirebaseAuth.instance.currentUser!.uid);
  }
  //** unfavoriting a turf */

  void unFavoriteATurf({
    required String turfId,
  }) async {
    _turfRepository.unFavoriteATurf(
        turfId: turfId, uid: FirebaseAuth.instance.currentUser!.uid);
  }

  //** seeing if the turf is favourited or not */
  Stream<List<Favorite>> isFavorited({required String turfId}) {
    return _turfRepository.isFavorited(
        turfId: turfId, uid: FirebaseAuth.instance.currentUser!.uid);
  }

  //** get all the availabel timeslots */

  Stream<Availibilty> getTimeAvailibilties(
      {required String turfId,
      required String dimensionId,
      required Timestamp selectedDate}) {
    return _turfRepository.getTimeAvailibilties(
        turfId: turfId, dimensionId: dimensionId, selectedDate: selectedDate);
  }

  //** rating a turf */
  void rateATurf({
    required String turfId,
    required Rating rating,
    required BuildContext context,
  }) async {
    final res = await _turfRepository.rateATurf(turfId: turfId, rating: rating);

    res.fold((l) => showSnackbar(context: context, text: l.message), (r) {
      changehasGivenReviewToTrue(context: context);
      showSnackbar(
          context: context,
          text: "Your rating submitted successfully",
          color: greenColor);
    });
  }

  //** change "hasGivenReview" To True (for review purposes) */
  void changehasGivenReviewToTrue({required BuildContext context}) async {
    final res = await _turfRepository.changehasGivenReviewToTrue(
        uid: FirebaseAuth.instance.currentUser!.uid);

    res.fold(
      (l) => showSnackbar(context: context, text: l.message),
      (r) => null,
    );
  }

  //** see of user has two bookings in the same turf to be elgible to  */
  Stream<List<Booking>> getTwoBookings({required String turfId}) {
    return _turfRepository.getTwoBookings(
        turfId: turfId, uid: FirebaseAuth.instance.currentUser!.uid);
  }
}
