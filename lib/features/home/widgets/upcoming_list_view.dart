import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/bookings/widgets/booking_block.dart';
import '../../../models/booking.dart';
import '../../auth/provider/user_data_notifer.dart';
import '../../bookings/repository/booking_repository.dart';

class UpcomingMatches extends ConsumerWidget {
  const UpcomingMatches({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataNotifierProvider);
    return SizedBox(
      height: 160,
      child: FirestoreListView<Booking>(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        pageSize: 2,
        query: ref
            .watch(bookingRepositoryProvider)
            .getUpcomingBookings(uid: user.uid),
        itemBuilder: (context, doc) {
          Booking booking = doc.data();

          return BookingTile(booking: booking);
        },
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorBuilder: (context, error, stackTrace) {
          if (kDebugMode) {
            print(error);
            print(stackTrace);
          }
          return Text(error.toString());
        },
        emptyBuilder: (context) => const Center(
          child: Text("No Upcoming Matches"),
        ),
      ),
    );
  }
}
