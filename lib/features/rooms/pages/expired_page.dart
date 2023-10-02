import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';
import 'package:turf_tracker/features/rooms/repository/rooms_repository.dart';
import 'package:turf_tracker/features/rooms/widgets/rooms_block.dart';
import 'package:turf_tracker/models/room.dart';

class ExpiredRoomsPage extends ConsumerWidget {
  const ExpiredRoomsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(userDataNotifierProvider.select((value) => value.uid));
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FirestoreListView<Room>(
              pageSize: 3,
              query: ref
                  .watch(roomRepositoryProvider)
                  .getExpiredRoomsByUid(uid: user),
              itemBuilder: (context, doc) {
                Room room = doc.data();

                return RoomsCard(room: room);
              },
              loadingBuilder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorBuilder: (context, error, stackTrace) {
                if (kDebugMode) {
                  print(stackTrace);
                }
                return Center(child: Text(error.toString()));
              },
              emptyBuilder: (context) => const Center(
                child: Text("No Rooms here"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
