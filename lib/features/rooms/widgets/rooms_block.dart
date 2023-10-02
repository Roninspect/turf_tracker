// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';
import 'package:turf_tracker/features/rooms/controller/room_controller.dart';

import 'package:turf_tracker/models/room.dart';
import 'package:turf_tracker/router/router.dart';

import '../../../common/colors.dart';

class RoomsCard extends ConsumerWidget {
  final Room room;
  const RoomsCard({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataNotifierProvider);
    final day = room.startTime.toDate().day;
    final weekday = DateFormat('EEEE').format(room.startTime.toDate());
    final month = DateFormat('MMM').format(room.startTime.toDate());
    final startTime = DateFormat('hh:mm a').format(room.startTime.toDate());
    final endTime = DateFormat('hh:mm a').format(room.endTime.toDate());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        "$day",
                        style: const TextStyle(
                            color: Colors.black, fontSize: 40, height: 0),
                      ),
                      Text(
                        month,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 40, height: 0),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        weekday,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          room.turfName,
                          style: const TextStyle(fontSize: 30, height: 0),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8.0).copyWith(left: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: greenColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "$startTime - $endTime",
                              style: const TextStyle(fontSize: 15, height: 0),
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
                            child: Row(
                              children: [
                                const Icon(
                                  MaterialCommunityIcons.currency_bdt,
                                  color: greenColor,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${room.totalPrice}",
                                  style:
                                      const TextStyle(fontSize: 15, height: 0),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0)
                                .copyWith(left: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.people,
                                  color: greenColor,
                                ),
                                const SizedBox(width: 5),
                                Row(
                                  children: [
                                    Text(
                                      room.whatByWhat,
                                      style: const TextStyle(
                                          fontSize: 15, height: 0),
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
                          const SizedBox(width: 140),
                          room.isActive && room.uid != user.uid
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: greenColor,
                                      minimumSize: const Size(0, 40)),
                                  onPressed: () => context.pushNamed(
                                      AppRoutes.confirmRoomPage.name,
                                      pathParameters: {'roomId': room.roomId},
                                      extra: room),
                                  child: const Text(
                                    "Join",
                                    style: TextStyle(color: Colors.white),
                                  ))
                              : room.isActive && room.uid == user.uid
                                  ? GestureDetector(
                                      onTap: () => ref
                                          .read(roomControllerProvider.notifier)
                                          .cancelRoom(
                                            roomId: room.roomId,
                                            context: context,
                                          ),
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 50.0),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                      ))
                                  : !room.isActive &&
                                          (room.uid == user.uid ||
                                              room.joinedBy == user.uid)
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: greenColor,
                                              minimumSize: const Size(0, 40)),
                                          onPressed: () => context.pushNamed(
                                              AppRoutes.confirmRoomPage.name,
                                              pathParameters: {
                                                'roomId': room.roomId
                                              },
                                              extra: room),
                                          child: const Text(
                                            "enter",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                      : const SizedBox.shrink(),
                          const SizedBox(width: 10),
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
