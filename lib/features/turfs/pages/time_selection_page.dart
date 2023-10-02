import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/common/custom_snackbar.dart';
import 'package:turf_tracker/features/turfs/controller/turf_controller.dart';
import 'package:turf_tracker/features/turfs/provider/availbilty_provider.dart';
import 'package:turf_tracker/features/turfs/provider/selected_timetable_provider.dart';
import 'package:turf_tracker/features/turfs/widgets/date_selector_listview.dart';
import 'package:turf_tracker/models/turf.dart';
import 'package:turf_tracker/router/router.dart';
import '../../../common/enums/slot_type.dart';
import '../../../models/availibilty.dart';
import '../provider/slot_type_selector_provider.dart';

class TimeSelectionPage extends ConsumerWidget {
  final Turf turf;
  const TimeSelectionPage({
    super.key,
    required this.turf,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Availibilty timeAvailibiltyFromTimeSelected =
        ref.watch(availibiltyNotifierProvider)!;
    final selectedSlotType = ref.watch(slotTypeNotifierProvider);

    final selectedTime = ref.watch(selectedTimeTableNotifierProvider);

    // // Function to calculate the color based on singleTimeAvailable properties
    // Color getCellColor(TimeTable singleTimeAvailable, bool isTimeSelected) {
    //   if (isTimeSelected) {
    //     return greenColor;
    //   } else if (singleTimeAvailable.isLocked) {
    //     return lockedColor;
    //   } else if (singleTimeAvailable.isAvailable) {
    //     return Colors.transparent; // Change this to another color if needed
    //   } else {
    //     return Colors.red;
    //   }
    // }

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                //** to reset the selected date and saved Availbilty model state */
                ref.invalidate(availibiltyNotifierProvider);
                ref.invalidate(selectedTimeTableNotifierProvider);
                ref.invalidate(slotTypeNotifierProvider);

                context.pop();
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text("Select Date and Time"),
          actions: [
            IconButton(
                onPressed: () {
                  // timeslotdialog(context: context);
                  ref.read(turfControllerProvider).resetTimeTable(
                      selectedAvailibilty: timeAvailibiltyFromTimeSelected,
                      context: context);
                  ref.invalidate(availibiltyNotifierProvider);
                  ref.invalidate(selectedTimeTableNotifierProvider);
                },
                icon: const Icon(
                  Icons.info,
                  color: Colors.white,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Date",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 10),
                DateSelectorListview(turf: turf),
                const SizedBox(height: 30),
                const Text(
                  "Select Slot Type",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 150,
                      child: ListTile(
                        onTap: () {
                          ref
                              .read(slotTypeNotifierProvider.notifier)
                              .selectSlotType(
                                  slotType: SlotType.oneHourAvailibilty);
                        },
                        shape: RoundedRectangleBorder(
                          //<-- SEE HERE
                          side: const BorderSide(width: 1, color: greenColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        tileColor:
                            selectedSlotType == SlotType.oneHourAvailibilty
                                ? greenColor
                                : Colors.transparent,
                        title: const Center(
                          child: Text("1 hour"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: ListTile(
                        onTap: () {
                          ref
                              .read(slotTypeNotifierProvider.notifier)
                              .selectSlotType(
                                  slotType: SlotType.oneHalfHourAvailibilty);
                        },
                        shape: RoundedRectangleBorder(
                          //<-- SEE HERE
                          side: const BorderSide(width: 1, color: greenColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        tileColor:
                            selectedSlotType == SlotType.oneHalfHourAvailibilty
                                ? greenColor
                                : Colors.transparent,
                        title: const Center(
                          child: Text("1 hour 30 min"),
                        ),
                      ),
                    ),
                  ],
                ),

                //** selecting time slot gridview */
                const SizedBox(height: 30),
                const Text(
                  "Select Time Slot",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 10),
                ref
                    .watch(getTimeAvailibiltiesProvider(TripleArgsModel(
                        turfId: timeAvailibiltyFromTimeSelected.turfId,
                        dimensionId: timeAvailibiltyFromTimeSelected.did,
                        selectedDate: timeAvailibiltyFromTimeSelected.date)))
                    .when(
                      data: (data) {
                        //** sorting the list beforehand from day to night */
                        selectedSlotType == SlotType.oneHourAvailibilty
                            ? data.oneHourAvailibilty.sort((a, b) => a.startTime
                                .toDate()
                                .compareTo(b.startTime.toDate()))
                            : data.oneHalfHourAvailibilty.sort((a, b) => a
                                .startTime
                                .toDate()
                                .compareTo(b.startTime.toDate()));

                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 70,
                                  mainAxisSpacing: 10),
                          itemCount:
                              selectedSlotType == SlotType.oneHourAvailibilty
                                  ? data.oneHourAvailibilty.length
                                  : data.oneHalfHourAvailibilty.length,
                          itemBuilder: (context, index) {
                            final singleTimeAvailable =
                                selectedSlotType == SlotType.oneHourAvailibilty
                                    ? data.oneHourAvailibilty[index]
                                    : data.oneHalfHourAvailibilty[index];
                            final startTimeOnly = DateFormat('h:mm a')
                                .format(singleTimeAvailable.startTime.toDate());
                            final endTimeOnly = DateFormat('h:mm a')
                                .format(singleTimeAvailable.endTime.toDate());

                            return GestureDetector(
                              onTap: () {
                                if (singleTimeAvailable.isLocked) {
                                  showSnackbar(
                                      context: context,
                                      text:
                                          "Somebody is considering booking this slot. Please try again in 5 to 10 minutes.",
                                      color: Colors.orangeAccent);
                                } else if (singleTimeAvailable.isAvailable ==
                                    false) {
                                  showSnackbar(
                                      context: context,
                                      text:
                                          "This slot is already booked, Please select another slot",
                                      color: Colors.red);
                                }
                                ref
                                    .read(selectedTimeTableNotifierProvider
                                        .notifier)
                                    .selectTimetable(
                                        timeTable: singleTimeAvailable);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: singleTimeAvailable.isLocked
                                          ? lockedColor
                                          : !singleTimeAvailable.isAvailable
                                              ? Colors.red
                                              : selectedTime ==
                                                      singleTimeAvailable
                                                  ? greenColor
                                                  : Colors.transparent,
                                      border: Border.all(
                                          color: singleTimeAvailable.isLocked
                                              ? lockedColor
                                              : singleTimeAvailable.isAvailable
                                                  ? greenColor
                                                  : Colors.red),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$startTimeOnly - $endTimeOnly",
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            MaterialCommunityIcons.currency_bdt,
                                            size: 23,
                                          ),
                                          Text(
                                            singleTimeAvailable.price
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        if (kDebugMode) {
                          print(stackTrace);
                        }
                        return const Center(
                          child: Text("Please Select a date"),
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (selectedSlotType != null &&
                selectedTime != null &&
                timeAvailibiltyFromTimeSelected !=
                    Availibilty(
                      timeId: "",
                      turfId: "",
                      did: "",
                      status: "",
                      date: Timestamp(0, 0),
                      dimension: "",
                      oneHalfHourAvailibilty: const [],
                      oneHourAvailibilty: const [],
                    )) {
              context.pushNamed(AppRoutes.paymentConfirm.name,
                  pathParameters: {
                    'name': turf.name,
                  },
                  extra: turf);

              ref.read(turfControllerProvider).lockingSelectedTimeSlot(
                  context: context,
                  selectedAvailability: timeAvailibiltyFromTimeSelected,
                  selectedSlot: selectedTime,
                  slotType: selectedSlotType);
            }
          },
          label: const Text('Continue'),
          icon: const Icon(
            Icons.done,
            color: Colors.white,
          ),
          backgroundColor: greenColor,
        ));
  }
}
 //is the grammar correct in this line "Someone is Considering to book this slot, Please try again later"?

