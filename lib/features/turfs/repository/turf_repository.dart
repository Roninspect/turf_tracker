import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:turf_tracker/common/enums/status.dart';

import 'package:turf_tracker/common/failure.dart';
import 'package:turf_tracker/common/typedefs.dart';
import 'package:turf_tracker/models/availibilty.dart';
import 'package:turf_tracker/models/booking.dart';
import 'package:turf_tracker/models/dimensions.dart';
import 'package:turf_tracker/models/favorites.dart';
import 'package:turf_tracker/models/rating.dart';
import 'package:turf_tracker/models/turf.dart';
import 'package:uuid/uuid.dart';

import '../../../common/enums/slot_type.dart';
import '../provider/slot_type_selector_provider.dart';

final turfRepositoryProvider = Provider<TurfRepository>((ref) {
  return TurfRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      ref: ref);
});

class TurfRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Ref _ref;
  TurfRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required Ref ref})
      : _firestore = firestore,
        _auth = auth,
        _ref = ref;

  //** fetching turfs by pre selected district */

  Stream<List<Turf>> fetchTurfByAlreadySelectedDistrict(
      {required String alreadySelectedDistrict}) {
    return _firestore
        .collection("turfs")
        .where("district", isEqualTo: alreadySelectedDistrict)
        .orderBy("name", descending: false)
        .snapshots()
        .map((event) => event.docs.map((e) => Turf.fromMap(e.data())).toList());
  }

  //* fetching dimensions according to turfId

  Stream<List<Dimensions>> fetchDimensionsByTurfId(
      {required String turfId, required String selectedSports}) {
    return _firestore
        .collection("dimensions")
        .where("tid", isEqualTo: turfId)
        .where('sports', arrayContains: selectedSports)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Dimensions.fromMap(e.data())).toList());
  }

  //** fetching time and date Availibilty by turf id and dimension name */
  Stream<List<Availibilty>> fetchTimeAvailable(
      {required String turfId, required String did}) {
    return _firestore
        .collection("time_availibilty")
        .where("turfId", isEqualTo: turfId)
        .where("did", isEqualTo: did)
        .where("status", isEqualTo: Status.Active.name)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Availibilty.fromMap(e.data())).toList());
  }

  //** locking selected time slots */

  FutureVoid lockingselectedtimeslots({
    required TimeTable selectedSlot,
    required SlotType slotType,
    required Availibilty selectedAvailability,
  }) async {
    try {
      bool shouldMarkUnavailable(TimeTable selectedSlot, TimeTable timeTable) {
        final startTime1 = selectedSlot.startTime.toDate();
        final endTime1 = selectedSlot.endTime.toDate();
        final startTime2 = timeTable.startTime.toDate();
        final endTime2 = timeTable.endTime.toDate();
        //checking intersection

        bool isIntersecting =
            !(endTime1.isBefore(startTime2) || startTime1.isAfter(endTime2));

        //checking similar

        bool isMatching = startTime1.isAtSameMomentAs(startTime2) &&
            endTime1.isAtSameMomentAs(endTime2);

        // checking 31 minutes
        bool isAfter30Minutes = false;
        if (slotType == SlotType.oneHalfHourAvailibilty &&
            timeTable.startTime
                    .toDate()
                    .toUtc()
                    .difference(selectedSlot.endTime.toDate().toUtc())
                    .inMinutes >=
                30 &&
            timeTable.startTime
                    .toDate()
                    .toUtc()
                    .difference(selectedSlot.endTime.toDate().toUtc())
                    .inMinutes <=
                31) {
          isAfter30Minutes = true;
        }

        return isIntersecting || isMatching || isAfter30Minutes;
      }

      List<TimeTable> markSlotsUnavailable(
          List<TimeTable> slots, TimeTable selectedSlot) {
        return slots.map((timeTable) {
          final isUnavailable = shouldMarkUnavailable(selectedSlot, timeTable);
          return isUnavailable ? timeTable.copyWith(isLocked: true) : timeTable;
        }).toList();
      }

      // Update the availability status of one-hour slots
      final updatedOneHourSlots = markSlotsUnavailable(
          selectedAvailability.oneHourAvailibilty, selectedSlot);

      // Update the availability status of one-and-a-half-hour slots
      final updatedOneHalfHourSlots = markSlotsUnavailable(
          selectedAvailability.oneHalfHourAvailibilty, selectedSlot);

      return slotType == SlotType.oneHalfHourAvailibilty
          ? right(await _firestore
              .collection('time_availibilty')
              .doc(selectedAvailability.timeId)
              .update({
              'oneHourAvailibilty': updatedOneHourSlots
                  .map((timeTable) => timeTable.toMap())
                  .toList(),
              'oneHalfHourAvailability': updatedOneHalfHourSlots
                  .map((timeTable) => timeTable.toMap())
                  .toList(),
            }))
          : right(await _firestore
              .collection('time_availibilty')
              .doc(selectedAvailability.timeId) // Replace with your document ID
              .update({
              'oneHourAvailibilty': updatedOneHourSlots
                  .map((timeTable) => timeTable.toMap())
                  .toList(),
              'oneHalfHourAvailability': updatedOneHalfHourSlots
                  .map((timeTable) => timeTable.toMap())
                  .toList(),
            }));
    } catch (e, stk) {
      if (kDebugMode) {
        print(stk);
      }
      return left(Failure(e.toString()));
    }
  }

  //** unlocking selected time slots */

  FutureVoid unlockingTimeLots({
    required TimeTable selectedSlot,
    required SlotType slotType,
    required Availibilty selectedAvailability,
  }) async {
    try {
      bool shouldMarkUnavailable(TimeTable selectedSlot, TimeTable timeTable) {
        // final startTime1 = selectedSlot.startTime.toDate();
        // final endTime1 = selectedSlot.endTime.toDate();
        // final timeSlotStartTime = timeTable.startTime.toDate();
        // final timeSlotEndTime = timeTable.endTime.toDate();

        final startTime1 = selectedSlot.startTime.toDate();
        final endTime1 = selectedSlot.endTime.toDate();
        final startTime2 = timeTable.startTime.toDate();
        final endTime2 = timeTable.endTime.toDate();

        //checking intersection

        bool isIntersecting =
            !(endTime1.isBefore(startTime2) || startTime1.isAfter(endTime2));

        //checking similar

        bool isMatching = startTime1.isAtSameMomentAs(startTime2) &&
            endTime1.isAtSameMomentAs(endTime2);

        //checking intersection

        // bool isIntersecting = (timeSlotStartTime.isAfter(startTime1) &&
        //         timeSlotStartTime.isBefore(endTime1)) ||
        //     (timeSlotEndTime.isAfter(startTime1) &&
        //         timeSlotEndTime.isBefore(endTime1)) ||
        //     (timeSlotStartTime.isBefore(startTime1) &&
        //         timeSlotEndTime.isAfter(endTime1));

        // //checking similar

        // bool isMatching = startTime1.isAtSameMomentAs(timeSlotStartTime) &&
        //     endTime1.isAtSameMomentAs(timeSlotEndTime);
        // checking 31 minutes
        bool isAfter30Minutes = false;
        if (slotType == SlotType.oneHalfHourAvailibilty &&
            timeTable.startTime
                    .toDate()
                    .toUtc()
                    .difference(selectedSlot.endTime.toDate().toUtc())
                    .inMinutes >=
                30 &&
            timeTable.startTime
                    .toDate()
                    .toUtc()
                    .difference(selectedSlot.endTime.toDate().toUtc())
                    .inMinutes <=
                31) {
          isAfter30Minutes = true;
        }

        return isIntersecting || isMatching || isAfter30Minutes;
      }

      List<TimeTable> markSlotsUnavailable(
          List<TimeTable> slots, TimeTable selectedSlot) {
        return slots.map((timeTable) {
          final isUnavailable = shouldMarkUnavailable(selectedSlot, timeTable);
          return isUnavailable
              ? timeTable.copyWith(isLocked: false)
              : timeTable;
        }).toList();
      }

      // Update the availability status of one-hour slots
      final updatedOneHourSlots = markSlotsUnavailable(
          selectedAvailability.oneHourAvailibilty, selectedSlot);

      // Update the availability status of one-and-a-half-hour slots
      final updatedOneHalfHourSlots = markSlotsUnavailable(
          selectedAvailability.oneHalfHourAvailibilty, selectedSlot);

      return slotType == SlotType.oneHalfHourAvailibilty
          ? right(await _firestore
              .collection('time_availibilty')
              .doc(selectedAvailability.timeId)
              .update({
              'oneHourAvailibilty': updatedOneHourSlots
                  .map((timeTable) => timeTable.toMap())
                  .toList(),
              'oneHalfHourAvailability': updatedOneHalfHourSlots
                  .map((timeTable) => timeTable.toMap())
                  .toList(),
            }))
          : right(await _firestore
              .collection('time_availibilty')
              .doc(selectedAvailability.timeId) // Replace with your document ID
              .update({
              'oneHourAvailibilty': updatedOneHourSlots
                  .map((timeTable) => timeTable.toMap())
                  .toList(),
              'oneHalfHourAvailability': updatedOneHalfHourSlots
                  .map((timeTable) => timeTable.toMap())
                  .toList(),
            }));
    } catch (e, stk) {
      if (kDebugMode) {
        print(stk);
      }
      return left(Failure(e.toString()));
    }
  }

  //*new method for making the slots unavailable

  FutureVoid updatingTimeSlotAfterBooking({
    required TimeTable selectedSlot,
    required SlotType slotType,
    required Availibilty selectedAvailability,
  }) async {
    try {
      bool shouldMarkUnavailable(TimeTable selectedSlot, TimeTable timeTable) {
        final startTime1 = selectedSlot.startTime.toDate();
        final endTime1 = selectedSlot.endTime.toDate();
        final startTime2 = timeTable.startTime.toDate();
        final endTime2 = timeTable.endTime.toDate();

        // bool isIntersecting =
        //     (startTime1.isAfter(startTime2) && startTime1.isBefore(endTime2)) ||
        //         (endTime1.isAfter(startTime2) && endTime1.isBefore(endTime2)) ||
        //         (startTime1.isBefore(startTime2) && endTime1.isAfter(endTime2));
        bool isIntersecting =
            !(endTime1.isBefore(startTime2) || startTime1.isAfter(endTime2));

        //checking similar

        bool isMatching = startTime1.isAtSameMomentAs(startTime2) &&
            endTime1.isAtSameMomentAs(endTime2);

        // // checking 31 minutes
        // bool isAfter30Minutes = false;
        // if (slotType == SlotType.oneHalfHourAvailibilty &&
        //     timeTable.startTime
        //             .toDate()
        //             .toUtc()
        //             .difference(selectedSlot.endTime.toDate().toUtc())
        //             .inMinutes >=
        //         30 &&
        //     timeTable.startTime
        //             .toDate()
        //             .toUtc()
        //             .difference(selectedSlot.endTime.toDate().toUtc())
        //             .inMinutes <=
        //         31) {
        //   isAfter30Minutes = true;
        // }

        // Checking for a 31-minute gap
        bool isAfter30Minutes = false;
        if (slotType == SlotType.oneHalfHourAvailibilty &&
            startTime2.isAfter(endTime1) &&
            startTime2.difference(endTime1).inMinutes >= 30 &&
            startTime2.difference(endTime1).inMinutes <= 31) {
          isAfter30Minutes = true;
        }

        return isIntersecting || isMatching || isAfter30Minutes;
      }

      List<TimeTable> markSlotsUnavailable(
          List<TimeTable> slots, TimeTable selectedSlot) {
        return slots.map((timeTable) {
          final isUnavailable = shouldMarkUnavailable(selectedSlot, timeTable);
          return isUnavailable
              ? timeTable.copyWith(isAvailable: false)
              : timeTable;
        }).toList();
      }

      // Update the availability status of one-hour slots
      final updatedOneHourSlots = markSlotsUnavailable(
          selectedAvailability.oneHourAvailibilty, selectedSlot);

      // Update the availability status of one-and-a-half-hour slots
      final updatedOneHalfHourSlots = markSlotsUnavailable(
          selectedAvailability.oneHalfHourAvailibilty, selectedSlot);

      return right(await _firestore
          .collection('time_availibilty')
          .doc(selectedAvailability.timeId)
          .update({
        'oneHourAvailibilty':
            updatedOneHourSlots.map((timeTable) => timeTable.toMap()).toList(),
        'oneHalfHourAvailability': updatedOneHalfHourSlots
            .map((timeTable) => timeTable.toMap())
            .toList(),
      }));
    } catch (e, stk) {
      if (kDebugMode) {
        print(stk);
      }
      return left(
        Failure(e.toString()),
      );
    }
  }

  //** favouriting a turf */

  FutureVoid favoriteATurf(
      {required String turfId, required String uid}) async {
    try {
      final uuid = const Uuid().v4();
      Favorite favoriteModel = Favorite(fid: uuid, turfId: turfId, uid: uid);
      return right(await _firestore
          .collection("favorites")
          .doc(uuid)
          .set(favoriteModel.toMap()));
    } catch (e, stk) {
      if (kDebugMode) {
        print(stk);
      }
      return left(Failure(e.toString()));
    }
  }

  //** unfavouriting a turf */

  FutureVoid unFavoriteATurf({
    required String uid,
    required String turfId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection("favorites")
          .where('uid', isEqualTo: uid)
          .where('turfId', isEqualTo: turfId)
          .get();
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return right(null);
    } catch (e, stk) {
      if (kDebugMode) {
        print(stk);
      }
      return left(Failure(e.toString()));
    }
  }

  //** seeing if the turf is favourited or not */
  Stream<List<Favorite>> isFavorited(
      {required String turfId, required String uid}) {
    return _firestore
        .collection("favorites")
        .where("turfId", isEqualTo: turfId)
        .where("uid", isEqualTo: uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Favorite.fromMap(e.data())).toList());
  }

//** get time slots */
  Stream<Availibilty> getTimeAvailibilties(
      {required String turfId,
      required String dimensionId,
      required Timestamp selectedDate}) {
    return _firestore
        .collection("time_availibilty")
        .where("turfId", isEqualTo: turfId)
        .where("did", isEqualTo: dimensionId)
        .where("date", isEqualTo: selectedDate)
        .snapshots()
        .map((event) => Availibilty.fromMap(event.docs.first.data()));
  }

  //** rate a turf */

  FutureVoid rateATurf({
    required String turfId,
    required Rating rating,
  }) async {
    try {
      return right(await _firestore.collection('turfs').doc(turfId).update({
        "ratings": FieldValue.arrayUnion([rating.toMap()])
      }));
    } catch (e, stk) {
      print(stk);
      return left(Failure(e.toString()));
    }
  }

  //** change "hasGivenReview" To True (for review purposes) */
  FutureVoid changehasGivenReviewToTrue({required String uid}) async {
    try {
      return right(await _firestore
          .collection("users")
          .doc(uid)
          .update({"hasGivenReview": true}));
    } catch (e, stk) {
      print(stk);
      return left(Failure(e.toString()));
    }
  }

  //** see of user has two bookings in the same turf to be elgible to  */
  Stream<List<Booking>> getTwoBookings(
      {required String turfId, required String uid}) {
    return _firestore
        .collection("bookings")
        .where("turfId", isEqualTo: turfId)
        .where("bookerid", isEqualTo: uid)
        .limit(2)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Booking.fromMap(e.data())).toList());
  }

  FutureVoid resetTimeTable({required Availibilty selectedAvailibilty}) async {
    try {
      final listOfHalf = selectedAvailibilty.oneHalfHourAvailibilty
          .map((e) => e.copyWith(isAvailable: true, isLocked: false));
      final listOfOne = selectedAvailibilty.oneHourAvailibilty
          .map((e) => e.copyWith(isAvailable: true, isLocked: false));

      return right(await _firestore
          .collection('time_availibilty')
          .doc(selectedAvailibilty.timeId) // Replace with your document ID
          .update({
        'oneHourAvailibilty':
            listOfOne.map((timeTable) => timeTable.toMap()).toList(),
        'oneHalfHourAvailability':
            listOfHalf.map((timeTable) => timeTable.toMap()).toList(),
      }));
    } catch (e, stk) {
      print(stk);
      return left(Failure(e.toString()));
    }
  }
}
