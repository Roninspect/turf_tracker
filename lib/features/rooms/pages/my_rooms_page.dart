import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/rooms/controller/room_controller.dart';
import 'package:turf_tracker/features/rooms/widgets/rooms_block.dart';
import 'package:turf_tracker/models/room.dart';

class MyRoomsPage extends ConsumerWidget {
  const MyRoomsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          ref.watch(getMyRoomsProvider).when(
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
                              child:
                                  Text("You haven't shared any rooms here")));
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
    );
  }
}
