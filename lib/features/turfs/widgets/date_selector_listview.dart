import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:turf_tracker/models/turf.dart';

import '../../../common/colors.dart';
import '../../../models/availibilty.dart';
import '../controller/turf_controller.dart';
import '../provider/availbilty_provider.dart';
import '../provider/dimension_selector_provider.dart';
import '../provider/selected_timetable_provider.dart';

class DateSelectorListview extends ConsumerWidget {
  final Turf turf;
  const DateSelectorListview({
    required this.turf,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final did = ref.watch(dimensionDidSelectionNotifierProvider);
    final Availibilty? timeAvailibiltyFromTimeSelected =
        ref.watch(availibiltyNotifierProvider);
    return SizedBox(
      height: 120,
      child: ref
          .watch(fetchTimeAvailableProvider(
              ArgsModel(turfId: turf.turfId, secondParams: did)))
          .when(
            data: (data) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final singleTimeAvailable = data[index];

                  final weekdayName = DateFormat('EEEE')
                      .format(singleTimeAvailable.date!.toDate());

                  final date = singleTimeAvailable.date!.toDate().day;
                  final monthNo = singleTimeAvailable.date!.toDate().month;
                  String monthName =
                      DateFormat('MMMM').format(DateTime(2023, monthNo));

                  bool idSelected =
                      timeAvailibiltyFromTimeSelected!.date!.toDate().day ==
                          date;

                  return data.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              ref
                                  .read(availibiltyNotifierProvider.notifier)
                                  .selectTime(
                                      selectedTime: singleTimeAvailable);
                              ref.invalidate(selectedTimeTableNotifierProvider);
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: idSelected
                                      ? greenColor
                                      : const Color.fromRGBO(0, 0, 0, 0),
                                  border: Border.all(
                                    color: greenColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  const SizedBox(height: 2),
                                  Text(monthName),
                                  Text(
                                    date.toString(),
                                    style: const TextStyle(fontSize: 50),
                                  ),
                                  Text(weekdayName),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const Center(
                          child: Text("Not Available in the Moment"));
                },
              );
            },
            error: (error, stackTrace) {
              if (kDebugMode) {
                print(stackTrace);
              }
              return Center(
                child: Text(error.toString()),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
