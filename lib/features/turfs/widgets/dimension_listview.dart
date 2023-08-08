// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/features/turfs/provider/dimension_selector_provider.dart';

import 'package:turf_tracker/models/turf.dart';

import '../controller/turf_controller.dart';

class DimensionsListView extends ConsumerWidget {
  final Turf turf;
  final String selectedSports;
  const DimensionsListView({
    super.key,
    required this.turf,
    required this.selectedSports,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDimension = ref.watch(dimensionSelectionNotifierProvider);
    return ref
        .watch(fetchDimensionsByTurfIdProvider(
            ArgsModel(turfId: turf.turfId, secondParams: selectedSports)))
        .when(
          data: (data) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final dimension = data[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: const Color(0xff062318),
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.network(
                            dimension.dimentionsPhotoUrl,
                            fit: BoxFit.contain,
                            height: 180,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Select:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17)),
                                  Radio(
                                    activeColor: Colors.greenAccent,
                                    value: dimension.whatBywhat,
                                    groupValue: selectedDimension,
                                    onChanged: (value) {
                                      ref
                                          .read(
                                              dimensionSelectionNotifierProvider
                                                  .notifier)
                                          .selectDimension(
                                              selectedDimension: value!);
                                    },
                                  ),
                                ],
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Players - ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: dimension.aVSb,
                                      style: const TextStyle(
                                          color: greenColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Dimension - ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: dimension.whatBywhat,
                                      style: const TextStyle(
                                          color: greenColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Length - ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: dimension.length,
                                      style: const TextStyle(
                                          color: greenColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Height - ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: dimension.height,
                                      style: const TextStyle(
                                          color: greenColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Width - ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: dimension.width,
                                      style: const TextStyle(
                                          color: greenColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        );
  }
}
