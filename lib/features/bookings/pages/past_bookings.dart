import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';
import 'package:turf_tracker/features/bookings/repository/booking_repository.dart';
import 'package:turf_tracker/models/booking.dart';

class PastBookingsPage extends ConsumerWidget {
  const PastBookingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Bookings History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: FirestoreListView<Booking>(
                pageSize: 5,
                query: ref
                    .watch(bookingRepositoryProvider)
                    .getPastBookings(uid: user.uid),
                itemBuilder: (context, doc) {
                  Booking booking = doc.data();
                  DateTime dateTime = booking.date.toDate();

                  String formattedDate = DateFormat('MMMM').format(dateTime);
                  String getFormattedDayWithSuffix(int day) {
                    if (day >= 11 && day <= 13) {
                      return '$day' 'th';
                    }
                    switch (day % 10) {
                      case 1:
                        return '$day' 'st';
                      case 2:
                        return '$day' 'nd';
                      case 3:
                        return '$day' 'rd';
                      default:
                        return '$day' 'th';
                    }
                  }

                  String formattedDayWithSuffix =
                      getFormattedDayWithSuffix(dateTime.day);

                  String finalFormat = '$formattedDayWithSuffix $formattedDate';

                  String formattedTime = DateFormat('hh:mm a').format(dateTime);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        //<-- SEE HERE

                        borderRadius: BorderRadius.circular(20),
                      ),
                      tileColor: Colors.red,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.turfName,
                                style: const TextStyle(fontSize: 25),
                              ),
                              SizedBox(
                                  width: 150, child: Text(booking.turfAddress)),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Starting from:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(formattedTime),
                              Text(finalFormat),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
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
                  child: Text("No Past Matches"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
