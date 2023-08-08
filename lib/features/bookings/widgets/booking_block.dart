// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:turf_tracker/models/booking.dart';
import 'package:turf_tracker/router/router.dart';

import '../../../common/colors.dart';

class BookingTile extends ConsumerWidget {
  final Booking booking;
  const BookingTile({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    String formattedDayWithSuffix = getFormattedDayWithSuffix(dateTime.day);

    String finalFormat = '$formattedDayWithSuffix $formattedDate';

    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: SizedBox(
        width: 350,
        height: 200,
        child: GestureDetector(
          onTap: () {
            context.pushNamed(AppRoutes.bookingDetails.name,
                extra: booking,
                pathParameters: {"bookingId": booking.bookerid});
          },
          child: ListTile(
            shape: RoundedRectangleBorder(
              //<-- SEE HERE
              side: const BorderSide(width: 2, color: Colors.white10),
              borderRadius: BorderRadius.circular(20),
            ),
            minVerticalPadding: 00,
            contentPadding: const EdgeInsets.only(left: 15),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 161,
                      child: Text(
                        booking.turfName,
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                    SizedBox(
                        width: 150,
                        child: Text(
                          booking.turfAddress,
                          overflow: TextOverflow.ellipsis,
                        )),
                    const SizedBox(height: 10)
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: greenColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Starting from:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(formattedTime),
                      Text(finalFormat),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
