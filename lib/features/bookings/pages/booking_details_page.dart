// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:turf_tracker/models/booking.dart';

class BookingDetailsPage extends ConsumerWidget {
  final Booking bookingModel;
  final String bookingId;
  const BookingDetailsPage({
    super.key,
    required this.bookingModel,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Extract seconds from the timestamp string
    int seconds =
        int.parse(bookingModel.paymentDateMade.split(',')[0].split('=')[1]);

    // Convert seconds to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

    // Format the date and time as "12.30 PM, 13th July"
    String formattedDate = DateFormat('hh:mm a, d MMMM, yyyy').format(dateTime);

    String formattedStartTime = DateFormat('hh:mm a, d MMMM, yyyy')
        .format(bookingModel.startTime.toDate());
    String formattedEndTime = DateFormat('hh:mm a, d MMMM, yyyy')
        .format(bookingModel.endTime.toDate());

    // Get the current date and time
    DateTime now = DateTime.now();

    // Determine if the payment date is in the past or not
    bool isPaymentInPast = now.isAfter(dateTime);

    // Show "Paid in Turf" if the payment date is in the past, otherwise show "To be Paid"
    String paymentStatus = isPaymentInPast ? "Paid in Turf" : "To be Paid";

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Payment Details",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text(
                  "Booked By: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  bookingModel.bookerName,
                ),
              ),
              ListTile(
                title: const Text(
                  "Booking Id: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: SizedBox(
                  width: 250,
                  child: Text(
                    bookingModel.bookingId,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  "Turf Name: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  bookingModel.turfName,
                ),
              ),
              ListTile(
                title: const Text(
                  "Payment Made At: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: SizedBox(
                  width: 150,
                  child: Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  "Payment Id: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: SizedBox(
                  width: 200,
                  child: Text(
                    bookingModel.paymentId,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  "Transaction Id: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: SizedBox(
                  width: 200,
                  child: Text(
                    bookingModel.transactionId,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  "Start Time: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  formattedStartTime,
                ),
              ),
              ListTile(
                title: const Text(
                  "Total value: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: SizedBox(
                  width: 200,
                  child: Text(
                    formattedEndTime,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  "Paid in Advance: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "BDT ${bookingModel.paidInAdvance}",
                ),
              ),
              ListTile(
                title: const Text(
                  "Total value: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: SizedBox(
                  width: 200,
                  child: Text(
                    "BDT ${bookingModel.totalPrice}",
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "$paymentStatus: ",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: SizedBox(
                  width: 200,
                  child: Text(
                    "BDT ${bookingModel.toBePaidInTurf}",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
