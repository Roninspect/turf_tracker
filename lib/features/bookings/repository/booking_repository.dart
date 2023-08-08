import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:turf_tracker/common/failure.dart';
import 'package:turf_tracker/common/typedefs.dart';
import 'package:turf_tracker/models/booking.dart';

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
}
