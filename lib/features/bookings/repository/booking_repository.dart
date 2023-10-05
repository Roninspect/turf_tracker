import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:turf_tracker/common/failure.dart';
import 'package:turf_tracker/common/typedefs.dart';
import 'package:turf_tracker/models/booking.dart';
import 'package:turf_tracker/models/room.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(firestore: FirebaseFirestore.instance);
});

class BookingRepository {
  final FirebaseFirestore _firestore;
  BookingRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Query<Booking> getUpcomingBookings({required String uid}) {
    final now = Timestamp.now();
    return _firestore
        .collection('bookings')
        .where("date", isGreaterThan: now)
        .where("bookerid", isEqualTo: uid)
        .orderBy("date")
        .withConverter<Booking>(
          fromFirestore: (snapshot, _) =>
              Booking.fromMap(snapshot.data() as Map<String, dynamic>),
          toFirestore: (user, _) => user.toMap(),
        );
  }

  Query<Booking> getPastBookings({required String uid}) {
    final now = Timestamp.now();
    return _firestore
        .collection('bookings')
        .where("date", isLessThan: now)
        .where("bookerid", isEqualTo: uid)
        .withConverter<Booking>(
          fromFirestore: (snapshot, _) =>
              Booking.fromMap(snapshot.data() as Map<String, dynamic>),
          toFirestore: (user, _) => user.toMap(),
        );
  }

  FutureVoid saveBookingDataToFirestore({required Booking bookingModel}) async {
    try {
      return right(await _firestore
          .collection("bookings")
          .doc(bookingModel.bookingId)
          .set(bookingModel.toMap()));
    } catch (e, stk) {
      if (kDebugMode) {
        print(stk);
      }
      return left(Failure(e.toString()));
    }
  }

  //** updating booking number count of an user (for review purposes) */
  FutureVoid increaseBookingCount({required String uid}) async {
    try {
      return right(await _firestore
          .collection("users")
          .doc(uid)
          .update({"bookingsNo": FieldValue.increment(1)}));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //** isShared checking */

  Stream<List<Room>> isSharedAlready({required String bookingId}) {
    return _firestore
        .collection("rooms")
        .where("bookingId", isEqualTo: bookingId)
        .snapshots()
        .map((event) => event.docs.map((e) => Room.fromMap(e.data())).toList());
  }

  //** update balance in turf_owners account */

  FutureVoid updateBalance(
      {required String turfId, required num amountAfterCommission}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> twSnapshots = await _firestore
          .collection("turf_owners")
          .where("turfId", isEqualTo: turfId)
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> owner
          in twSnapshots.docs) {
        // Get the existing balance
        num currentBalance = owner.data()['balance'];

        // Calculate the new balance (for example, subtracting the commission)
        num newBalance = currentBalance + amountAfterCommission;

        // Update the balance in Firestore
        await _firestore
            .collection('turf_owners')
            .doc(owner.id)
            .update({'balance': newBalance});
      }

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    }
  }
}
