import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/rooms/controller/room_controller.dart';
import 'package:turf_tracker/features/rooms/widgets/rooms_block.dart';
import 'package:turf_tracker/models/room.dart';

import '../../auth/provider/district_provider.dart';
import '../../turfs/provider/district_change_notifier.dart';

class AllRoomsPage extends ConsumerWidget {
  const AllRoomsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? selectedDistrict = ref.watch(districtChangeNotifierProvider);
    final changeDistrict = ref.watch(registerDistrictSelectingNotifierProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Rooms Available",
                  style: TextStyle(fontSize: 20),
                ),
                DropdownButton<String>(
                  value: selectedDistrict!.isNotEmpty
                      ? selectedDistrict
                      : changeDistrict,
                  items: const [
                    DropdownMenuItem(value: "Dhaka", child: Text("Dhaka")),
                    DropdownMenuItem(
                        value: "Chittagong", child: Text("Chittagong")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(districtChangeNotifierProvider.notifier)
                          .fetchDiferentDistrict(selectedDistrict: value);
                    }
                  },
                ),
              ],
            ),
            ref
                .watch(getAllActiveRoomsByDistrictProvider(selectedDistrict))
                .when(
                  data: (rooms) {
                    return rooms.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: rooms.length,
                              itemBuilder: (context, index) {
                                final Room room = rooms[index];

                                return RoomsCard(
                                  room: room,
                                );
                              },
                            ),
                          )
                        : const Expanded(
                            child: Center(
                            child: Text("No Active Rooms"),
                          ));
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(error.toString()),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
          ],
        ),
      ),
    );
  }
}
