import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';
import 'package:turf_tracker/features/bookings/repository/booking_repository.dart';
import 'package:turf_tracker/features/bookings/widgets/booking_block.dart';
import 'package:turf_tracker/models/booking.dart';

class UpComingPage extends ConsumerWidget {
  const UpComingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataNotifierProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: FirestoreListView<Booking>(
                pageSize: 3,
                query: ref
                    .watch(bookingRepositoryProvider)
                    .getUpcomingBookings(uid: user.uid),
                itemBuilder: (context, doc) {
                  Booking booking = doc.data();

                  return SizedBox(
                      height: 130,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: BookingTile(booking: booking),
                      ));
                },
                loadingBuilder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (context, error, stackTrace) {
                  if (kDebugMode) {
                    print(stackTrace);
                  }
                  return Text(error.toString());
                },
                emptyBuilder: (context) => const Center(
                  child: Text("No Upcoming Matches"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
