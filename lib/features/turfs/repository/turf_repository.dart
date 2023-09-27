import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:turf_tracker/common/failure.dart';
import 'package:turf_tracker/common/typedefs.dart';
import 'package:turf_tracker/models/availibilty.dart';
import 'package:turf_tracker/models/booking.dart';
import 'package:turf_tracker/models/dimensions.dart';
import 'package:turf_tracker/models/favorites.dart';
import 'package:turf_tracker/models/rating.dart';
import 'package:turf_tracker/models/turf.dart';
import 'package:uuid/uuid.dart';

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
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Availibilty.fromMap(e.data())).toList());
  }

  // //** locking selected time slots */

  // FutureVoid lockingselectedtimeslots({
  //   required List<int> timetableIndices,
  //   required List<TimeTable> updatedTimetables,
  //   required String timeId,
  // }) async {
  //   try {
  //     final availabilityDoc =
  //         await _firestore.collection("time_availibilty").doc(timeId).get();

  //     List<TimeTable> existingTimetableList =
  //         List.from(availabilityDoc.data()!['availibility'] as List)
  //             .map((map) => TimeTable.fromMap(map))
  //             .toList();

  //     for (int i = 0; i < timetableIndices.length; i++) {
  //       int index = timetableIndices[i];
  //       if (index >= 0 && index < existingTimetableList.length) {
  //         existingTimetableList[index] = TimeTable(
  //           isAvailable: true, // Update the isAvailable field to false
  //           isLocked: true,
  //           time: updatedTimetables[i].time,
  //           price: updatedTimetables[i].price,
  //         );
  //       }
  //     }

  //     return right(
  //         await _firestore.collection("time_availibilty").doc(timeId).update({
  //       'availibility': existingTimetableList
  //           .map((timetable) => timetable.toMap())
  //           .toList(),
  //     }));
  //   } catch (e, stk) {
  //     if (kDebugMode) {
  //       print(stk);
  //     }
  //     return left(Failure(e.toString()));
  //   }
  // }

  // //** unlocking selected time slots */

  // FutureVoid unlockingTimeLots({
  //   required List<int> timetableIndices,
  //   required List<TimeTable> updatedTimetables,
  //   required String timeId,
  // }) async {
  //   try {
  //     final availabilityDoc =
  //         await _firestore.collection("time_availibilty").doc(timeId).get();

  //     List<TimeTable> existingTimetableList =
  //         List.from(availabilityDoc.data()!['availibility'] as List)
  //             .map((map) => TimeTable.fromMap(map))
  //             .toList();

  //     for (int i = 0; i < timetableIndices.length; i++) {
  //       int index = timetableIndices[i];
  //       if (index >= 0 && index < existingTimetableList.length) {
  //         existingTimetableList[index] = TimeTable(
  //           isAvailable: true, // Update the isAvailable field to false
  //           isLocked: false,
  //           time: updatedTimetables[i].time,
  //           price: updatedTimetables[i].price,
  //         );
  //       }
  //     }

  //     return right(
  //         await _firestore.collection("time_availibilty").doc(timeId).update({
  //       'availibility': existingTimetableList
  //           .map((timetable) => timetable.toMap())
  //           .toList(),
  //     }));
  //   } catch (e, stk) {
  //     if (kDebugMode) {
  //       print(stk);
  //     }
  //     return left(Failure(e.toString()));
  //   }
  // }

  FutureVoid updateTimeSlotAfterBooking(
      {required TimeTable selectedSlot,
      required SlotType slotType,
      required Availibilty selectedAvailibilty}) async {
    try {
//** booking all the slots that is intersecting the selected Slot */
      bool isTimeSlotIntersecting(
          TimeTable timeTable, Timestamp startTime, Timestamp endTime) {
        final timeSlotStartTime = timeTable.startTime.toDate();
        final timeSlotEndTime = timeTable.endTime.toDate();
        return (timeSlotStartTime.isAfter(startTime.toDate()) &&
                timeSlotStartTime.isBefore(endTime.toDate())) ||
            (timeSlotEndTime.isAfter(startTime.toDate()) &&
                timeSlotEndTime.isBefore(endTime.toDate())) ||
            (timeSlotStartTime.isBefore(startTime.toDate()) &&
                timeSlotEndTime.isAfter(endTime.toDate()));
      }

      final updatedOneHourSlots =
          selectedAvailibilty.oneHourAvailibilty.map((timeTable) {
        if (isTimeSlotIntersecting(
            timeTable, selectedSlot.startTime, selectedSlot.endTime)) {
          return timeTable.copyWith(isAvailable: false);
        }
        return timeTable;
      }).toList();

      final updatedOneHalfHourSlots =
          selectedAvailibilty.oneHalfHourAvailibilty.map((timeTable) {
        if (isTimeSlotIntersecting(
            timeTable, selectedSlot.startTime, selectedSlot.endTime)) {
          return timeTable.copyWith(isAvailable: false);
        }
        return timeTable;
      }).toList();

      //** Mark the selected slot as booked
      final updatedSelectedSlot = selectedSlot.copyWith(isAvailable: false);

      //**  Find and replace the selected slot in the arrays
      final updatedOneHourSlotsIndex = updatedOneHourSlots.indexWhere(
          (timeTable) =>
              timeTable.startTime == selectedSlot.startTime &&
              timeTable.endTime == selectedSlot.endTime);

      if (updatedOneHourSlotsIndex != -1) {
        updatedOneHourSlots[updatedOneHourSlotsIndex] = updatedSelectedSlot;
      }

      final updatedOneHalfHourSlotsIndex = updatedOneHalfHourSlots.indexWhere(
          (timeTable) =>
              timeTable.startTime == selectedSlot.startTime &&
              timeTable.endTime == selectedSlot.endTime);

      if (updatedOneHalfHourSlotsIndex != -1) {
        updatedOneHalfHourSlots[updatedOneHalfHourSlotsIndex] =
            updatedSelectedSlot;
      }

//** problem is here where i want to also book all the slots that have 30 minute gap
//**  if o book for start time 6:00 and end time is 7:30pm then it should also make isAvailable: false for 8:00 pm */

      List<TimeTable> newUpdatedOneHOurList = [];
      List<TimeTable> newUpdatedOneHalfHourList = [];

      if (slotType == SlotType.oneHalfHourAvailibilty) {
        newUpdatedOneHOurList = updatedOneHourSlots.map((e) {
          if (e.startTime
                  .toDate()
                  .difference(selectedSlot.endTime.toDate().toUtc())
                  .inMinutes ==
              31) {
            print(
                'Updating 30-minute gap slot in 1 hour: ${e.startTime} - ${e.endTime}');
            return e.copyWith(isAvailable: false);
          }
          return e;
        }).toList();

        newUpdatedOneHalfHourList = updatedOneHalfHourSlots.map((e) {
          if (e.startTime
                  .toDate()
                  .isAfter(selectedSlot.endTime.toDate().toUtc()) &&
              e.startTime
                      .toDate()
                      .difference(selectedSlot.endTime.toDate())
                      .inMinutes ==
                  31) {
            print(
                'Updating 30-minute gap slot in 1.5 hour: ${e.startTime} - ${e.endTime}');
            return e.copyWith(isAvailable: false);
          }
          return e;
        }).toList();
      }

      return slotType == SlotType.oneHalfHourAvailibilty
          ? right(await _firestore
              .collection('time_availibilty')
              .doc(selectedAvailibilty.timeId)
              .update({
              'oneHourAvailibilty': newUpdatedOneHOurList
                  .map((timeTable) => timeTable.toMap())
                  .toList(),
              'oneHalfHourAvailability': newUpdatedOneHalfHourList
                  .map((timeTable) => timeTable.toMap())
                  .toList(),
            }))
          : right(await _firestore
              .collection('time_availibilty')
              .doc(selectedAvailibilty.timeId) // Replace with your document ID
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
      return left(
        Failure(e.toString()),
      );
    }
  }

  //new method for making the slots unavailable

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

        //checking intersection

        bool isIntersecting = (startTime1.isAfter(startTime2) && startTime1.isBefore(endTime2)) ||
            (endTime1.isAfter(startTime2) && endTime1.isBefore(endTime2)) ||
            (startTime1.isBefore(startTime2) && endTime1.isAfter(endTime2));

        //checking similar
        bool isMatching = startTime1.isAtSameMomentAs(startTime2) && endTime1.isAtSameMomentAs(endTime2);

        // checking 31 minutes
        bool isAfter30Minutes = false;
        if (timeTable.startTime.toDate().toUtc().difference(selectedSlot.endTime.toDate().toUtc()).inMinutes >= 30 &&
            timeTable.startTime.toDate().toUtc().difference(selectedSlot.endTime.toDate().toUtc()).inMinutes <= 31) {
          isAfter30Minutes = true;
        }
        print('Selected: ${DateFormat.jm().format(selectedSlot.startTime.toDate())} To ${DateFormat.jm().format(selectedSlot.endTime.toDate())}');
        print('${DateFormat.jm().format(timeTable.startTime.toDate())} To ${DateFormat.jm().format(timeTable.endTime.toDate())}');
        print(isAfter30Minutes);

        return isIntersecting || isMatching || isAfter30Minutes;
      }



      List<TimeTable> markSlotsUnavailable(List<TimeTable> slots, TimeTable selectedSlot) {
        return slots.map((timeTable) {
          final isUnavailable = shouldMarkUnavailable(selectedSlot, timeTable);
          return isUnavailable  ? timeTable.copyWith(isAvailable: false) : timeTable;
        }).toList();
      }


      // Update the availability status of one-hour slots
      final updatedOneHourSlots = markSlotsUnavailable(selectedAvailability.oneHourAvailibilty, selectedSlot);

      // Update the availability status of one-and-a-half-hour slots
      final updatedOneHalfHourSlots = markSlotsUnavailable(selectedAvailability.oneHalfHourAvailibilty, selectedSlot);

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

  //** favouriting a turf */

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
          .map((e) => e.copyWith(isAvailable: true));
      final listOfOne = selectedAvailibilty.oneHourAvailibilty
          .map((e) => e.copyWith(isAvailable: true));

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
