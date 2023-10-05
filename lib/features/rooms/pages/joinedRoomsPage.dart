import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/rooms/controller/room_controller.dart';
import 'package:turf_tracker/features/rooms/widgets/rooms_block.dart';
import 'package:turf_tracker/models/room.dart';
import '../../turfs/provider/district_change_notifier.dart';

class AllJoinedRoomsPage extends ConsumerWidget {
  const AllJoinedRoomsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? selectedDistrict = ref.watch(districtChangeNotifierProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          children: [
            ref
                .watch(getAllInactiveRoomsByDistrictProvider(selectedDistrict!))
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
                              child: Text("No Rooms here"),
                            ),
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
                )
          ],
        ),
      ),
    );
  }
}
