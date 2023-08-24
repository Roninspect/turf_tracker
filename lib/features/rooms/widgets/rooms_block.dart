import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/router/router.dart';

import '../../../common/colors.dart';

class RoomsCard extends ConsumerWidget {
  const RoomsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Rooms Available",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 170,
            decoration: const BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Container(
                  width: 120,
                  decoration: const BoxDecoration(
                      color: greenColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Column(
                    children: [
                      SizedBox(height: 5),
                      Text(
                        "12",
                        style: TextStyle(
                            color: Colors.black, fontSize: 40, height: 0),
                      ),
                      Text(
                        "Jan",
                        style: TextStyle(
                            color: Colors.black, fontSize: 40, height: 0),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Friday",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Frenzy Arena",
                          style: TextStyle(fontSize: 30, height: 0),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8.0).copyWith(left: 8),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: greenColor,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "12:00 PM - 1:30 PM",
                              style: TextStyle(fontSize: 15, height: 0),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0)
                                .copyWith(left: 8),
                            child: const Row(
                              children: [
                                Icon(
                                  MaterialCommunityIcons.currency_bdt,
                                  color: greenColor,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "500 BDT",
                                  style: TextStyle(fontSize: 15, height: 0),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0)
                                .copyWith(left: 8),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  color: greenColor,
                                ),
                                SizedBox(width: 5),
                                Row(
                                  children: [
                                    Text(
                                      "6v6",
                                      style: TextStyle(fontSize: 15, height: 0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 150),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: greenColor,
                                  minimumSize: const Size(0, 40)),
                              onPressed: () => context
                                  .pushNamed(AppRoutes.confirmRoomPage.name),
                              child: const Text(
                                "Join",
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
