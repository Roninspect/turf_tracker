// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/features/rooms/controller/room_controller.dart';
import 'package:turf_tracker/features/rooms/pages/accepted_by_page.dart';
import 'package:turf_tracker/features/rooms/pages/booked_by_page.dart';
import 'package:turf_tracker/features/rooms/provider/confirm_room_tab_provider.dart';
import 'package:turf_tracker/models/room.dart';

class ConfirmRoomPage extends ConsumerWidget {
  final Room room;
  final String roomId;
  const ConfirmRoomPage({
    super.key,
    required this.room,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(roomTabIndexNotifierProvider);
    final bool isLoading = ref.watch(roomControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(room.turfName),
      ),
      body: ref.watch(getRoomByIdProvider(roomId)).when(
            data: (newRoom) {
              return DefaultTabController(
                initialIndex: index,
                length: newRoom.isActive ? 1 : 2,
                child: Column(
                  children: [
                    TabBar(
                        labelColor: index == 0 ? greenColor : Colors.redAccent,
                        indicatorColor:
                            index == 0 ? greenColor : Colors.redAccent,
                        onTap: (value) {
                          ref
                              .read(roomTabIndexNotifierProvider.notifier)
                              .changeIndex(selectedValue: value);
                        },
                        tabs: [
                          const Tab(
                            text: "Booked By",
                          ),
                          if (!newRoom.isActive)
                            const Tab(
                              text: "Accepted By",
                            )
                        ]),
                    Expanded(
                      child: TabBarView(
                        children: [
                          BookedByPage(room: newRoom),
                          if (!newRoom.isActive) AcceptedByPage(room: newRoom),
                        ],
                      ),
                    ),
                    isLoading
                        ? FloatingActionButton.extended(
                            onPressed: () {},
                            label: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            backgroundColor: greenColor,
                          )
                        : newRoom.isActive
                            ? FloatingActionButton.extended(
                                onPressed: () async {
                                  ref
                                      .read(roomControllerProvider.notifier)
                                      .joinRoom(
                                          roomId: roomId, context: context);
                                },
                                label: const Text("Join The Room"),
                                backgroundColor: greenColor,
                              )
                            : const SizedBox.shrink(),
                    const SizedBox(
                      height: 150,
                    )
                  ],
                ),
              );
            },
            error: (error, stackTrace) {
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
