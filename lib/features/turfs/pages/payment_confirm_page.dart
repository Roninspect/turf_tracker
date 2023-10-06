// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bkash/flutter_bkash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/common/custom_snackbar.dart';
import 'package:turf_tracker/common/enums/book_type.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';
import 'package:turf_tracker/features/turfs/provider/slot_type_selector_provider.dart';
import 'package:turf_tracker/models/turf.dart';
import 'package:uuid/uuid.dart';
import '../../../models/booking.dart';
import '../../../models/discount.dart';
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
  late Timer timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    timer = Timer(const Duration(minutes: 7), () {
      unlockSelectedTimeSlots(willPop: true);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      unlockSelectedTimeSlots(willPop: true);
    } else if (state == AppLifecycleState.detached) {
      Timer(const Duration(minutes: 7), () {
        unlockSelectedTimeSlots(willPop: true);
      });
    } else if (state == AppLifecycleState.paused) {
      unlockSelectedTimeSlots(willPop: true);
    }
  }

  void unlockSelectedTimeSlots({required bool willPop}) {
    ref.read(turfControllerProvider).unlockingSelectedTimeSlot(
        context: context,
        selectedAvailability: ref.read(availibiltyNotifierProvider)!,
        selectedSlot: ref.read(selectedTimeTableNotifierProvider)!,
        slotType: ref.read(slotTypeNotifierProvider)!);
    ref.invalidate(selectedTimeTableNotifierProvider);
    willPop ? popTwice() : null;
  }

  void popTwice() {
    context.pop();
    context.pop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unlockSelectedTimeSlots(willPop: true);
    timer.cancel();
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

    final startTime = timelist != null
        ? DateFormat("hh:mm a").format(timelist.startTime.toDate())
        : "Not Available";
    final endTime = timelist != null
        ? DateFormat("hh:mm a").format(timelist.endTime.toDate())
        : "Not Available";

    //* Use DateFormat to format the date, month, and weekday
    DateTime dateTime = avalibilty.date.toDate();

    String formattedMonth = DateFormat('MMMM').format(avalibilty.date.toDate());
    String formattedWeekday =
        DateFormat('EEEE').format(avalibilty.date.toDate());

    String getFormattedDay(int day) {
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

    String formattedDay = getFormattedDay(dateTime.day);

    String finalFormat = '$formattedDay $formattedMonth, $formattedWeekday';

    num totalPrice = timelist != null ? timelist.price : 0;
    num advancePaid = 0.3 * totalPrice;

    bool discountApplicable =
        widget.turf.discounts.any((e) => user.uid == e.uid);

    Discount? matchingDiscount = widget.turf.discounts.firstWhere(
        (e) => user.uid == e.uid,
        orElse: () => Discount(uid: "", userName: "userName", amount: 0)
        // Handle the case where no matching discount is found
        );

    num discountPercent = 0;

// Now, matchingDiscount contains the Discount object or null if no match was found
    if (matchingDiscount.amount != 0) {
      discountPercent = matchingDiscount.amount;
    }

    num toBePaidInTurf = discountApplicable
        ? (totalPrice - (totalPrice * (discountPercent / 100))) - advancePaid
        : totalPrice - advancePaid;

    num turfOwnerWillGet =
        advancePaid - (totalPrice * (widget.turf.commission_percentage / 100));

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
                    "Advance(To book the slot)",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "BDT $advancePaid",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (discountApplicable)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Discounts Given By Turf",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "$discountPercent%",
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
                    "BDT $toBePaidInTurf",
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
          backgroundColor: const Color(0xffE3106E),
          onPressed: () async {
            if (timelist != null) {
              if (user.phoneNumber.isNotEmpty) {
                // try {
                // final res = await flutterBkash.pay(
                //   context: context, // BuildContext context
                //   amount: advancePaid.toDouble(), // amount as double
                //   merchantInvoiceNumber: "invoice123",
                // );

                // if (res.trxId != "") {
                if (mounted) {
                  ref.read(turfControllerProvider).updateTimeSlotAfterBooking(
                      selectedSlot: timelist,
                      slotType: selectedSlotType!,
                      selectedAvailibilty: avalibilty,
                      context: context);

                  ref
                      .read(bookingControllerProvider.notifier)
                      .saveBookingDataToFirestore(
                          bookingModel: Booking(
                              bookingId: const Uuid().v4(),
                              bookedBy: BookedBy.User.name,
                              bookerid: user.uid,
                              bookerName: user.name,
                              turfName: widget.turf.name,
                              turfAddress: widget.turf.address,
                              startTime: timelist.startTime,
                              bookedAt: Timestamp.now(),
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

                  ref.read(bookingControllerProvider.notifier).updateBalance(
                      turfId: widget.turf.turfId,
                      amountAfterCommission: turfOwnerWillGet);

                  //   //** invalidating or resetting the selected data */
                  ref.invalidate(availibiltyNotifierProvider);
                  ref.invalidate(selectedTimeTableNotifierProvider);

                  context.pop();
                }
                //   // }
                // } on BkashFailure catch (e) {
                //   showSnackbar(context: context, text: e.message);
                // }
              } else {
                showSnackbar(
                    color: Colors.redAccent,
                    context: context,
                    text:
                        "You Don't Have Any Phone Number, Please Add Your Phone Number");
              }
            }
          },
          label: const Text(
            "Pay with Bkash",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
