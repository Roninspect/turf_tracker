// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bkash/flutter_bkash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';
import 'package:turf_tracker/features/turfs/provider/slot_type_selector_provider.dart';
import 'package:turf_tracker/models/turf.dart';
import 'package:uuid/uuid.dart';
import '../../../models/booking.dart';
import '../../bookings/controller/booking_controller.dart';
import '../controller/turf_controller.dart';
import '../provider/availbilty_provider.dart';
import '../provider/dimension_selector_provider.dart';
import '../provider/selected_timetable_provider.dart';

class PaymentConfirmPage extends ConsumerStatefulWidget {
  final Turf turf;
  const PaymentConfirmPage({
    super.key,
    required this.turf,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaymentConfirmPageState();
}

class _PaymentConfirmPageState extends ConsumerState<PaymentConfirmPage>
    with WidgetsBindingObserver {
  final flutterBkash = FlutterBkash();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Timer(const Duration(minutes: 3), () {
      unlockSelectedTimeSlots(willPop: true);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      unlockSelectedTimeSlots(willPop: true);
    } else if (state == AppLifecycleState.detached) {
      Timer(const Duration(minutes: 1), () {
        unlockSelectedTimeSlots(willPop: true);
      });
    } else if (state == AppLifecycleState.paused) {
      unlockSelectedTimeSlots(willPop: true);
    }
  }

  void unlockSelectedTimeSlots({required bool willPop}) {
    // ref.read(turfControllerProvider).unlockingSelectedTimeSlot(
    //     timetableIndices: ref.read(listOfTimeTableIndicesNotifierProvider),
    //     updatedTimetables: ref.read(selectedTimeTableNotifierProvider),
    //     context: context,
    //     timeId: ref.read(availibiltyNotifierProvider).timeId);
    ref.invalidate(selectedTimeTableNotifierProvider);
    willPop ? context.pop() : null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unlockSelectedTimeSlots(willPop: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avalibilty = ref.watch(availibiltyNotifierProvider);
    final timelist = ref.watch(selectedTimeTableNotifierProvider);
    final dimensionSlected = ref.watch(aVSbSelectionNotifierProvider);
    final selectedSlotType = ref.watch(slotTypeNotifierProvider);
    final user = ref.watch(userDataNotifierProvider);

    //* formatting selectedTime
    final startTime =
        DateFormat("hh:mm a").format(timelist!.startTime.toDate());
    final endTime = DateFormat("hh:mm a").format(timelist.endTime.toDate());

    //* Use DateFormat to format the date, month, and weekday
    DateTime dateTime = avalibilty.date.toDate();

    String formattedMonth = DateFormat('MMMM').format(avalibilty.date.toDate());
    String formattedWeekday =
        DateFormat('EEEE').format(avalibilty.date.toDate());

    String _getFormattedDay(int day) {
      if (day >= 11 && day <= 13) {
        return '${day}th';
      }
      switch (day % 10) {
        case 1:
          return '${day}st';
        case 2:
          return '${day}nd';
        case 3:
          return '${day}rd';
        default:
          return '${day}th';
      }
    }

    String formattedDay = _getFormattedDay(dateTime.day);

    String finalFormat = '$formattedDay $formattedMonth, $formattedWeekday';

    num totalPrice = timelist.price;
    num advancePaid = 500;

    num toBePaidInTurf = totalPrice - advancePaid;

    return WillPopScope(
      onWillPop: () async {
        unlockSelectedTimeSlots(willPop: false);
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                unlockSelectedTimeSlots(willPop: true);
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text("Confirm Your Turf"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Dimension:",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    dimensionSlected,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Date:",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    finalFormat,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Starting Time:",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    startTime,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Ending Time:",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    endTime,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "BDT $totalPrice",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Advance(To book the slots):",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "BDT $advancePaid",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Give to the turf (in person)",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "BDT ${totalPrice - advancePaid}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Spacer(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: greenColor,
          onPressed: () async {
            ref.read(turfControllerProvider).updateTimeSlotAfterBooking(
                selectedSlot: timelist,
                slotType: selectedSlotType!,
                selectedAvailibilty: avalibilty,
                context: context);
            // await flutterBkash.pay(
            //   context: context, // BuildContext context
            //   amount: totalPrice.toDouble(), // amount as double
            //   merchantInvoiceNumber: "invoice123",
            // );

            // if (avalibilty ==
            //         Availibilty(
            //             timeId: "",
            //             turfId: "",
            //             did: "",
            //             status: "",
            //             date: Timestamp(0, 0),
            //             dimension: "",
            //             availibility: []) ||
            //     listofTime == []) {
            //   showSnackbar(
            //       context: context, text: "Please Select Date and Time Slot");
            // } else {

            ref
                .read(bookingControllerProvider.notifier)
                .saveBookingDataToFirestore(
                    bookingModel: Booking(
                        bookingId: const Uuid().v4(),
                        bookerid: user.uid,
                        bookerName: user.name,
                        turfName: widget.turf.name,
                        turfAddress: widget.turf.address,
                        startTime: timelist.startTime,
                        endTime: timelist.endTime,
                        whatByWhat: dimensionSlected,
                        date: timelist.startTime,
                        phoneNumber: user.phoneNumber,
                        transactionId: const Uuid().v4(),
                        paymentId: const Uuid().v4(),
                        paymentDateMade: Timestamp.now().toString(),
                        totalPrice: totalPrice,
                        paidInAdvance: advancePaid,
                        toBePaidInTurf: toBePaidInTurf,
                        district: widget.turf.district,
                        turfId: widget.turf.turfId,
                        isShared: false),
                    context: context);

            //   //** invalidating or resetting the selected data */
            ref.invalidate(availibiltyNotifierProvider);
            ref.invalidate(selectedTimeTableNotifierProvider);

            context.pop();

            //   showSnackbar(
            //       context: context,
            //       color: Colors.green,
            //       text: "Booked Successfully");
            // }
          },
          label: const Text(
            "Proceed To Payment",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
