// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:turf_tracker/models/room.dart';

class BookedByPage extends ConsumerWidget {
  final Room room;
  const BookedByPage({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startTime = DateFormat('hh:mm a').format(room.startTime.toDate());
    final endTime = DateFormat('hh:mm a').format(room.endTime.toDate());
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 16 / 9),
              children: [
                ListTile(
                  title: const Text("Booked By:"),
                  subtitle: Text(room.bookedBy),
                ),
                ListTile(
                  title: const Text("Turf Name:"),
                  subtitle: Text(room.turfName),
                ),
                ListTile(
                  title: const Text("versus:"),
                  subtitle: Text(room.whatByWhat),
                ),
                ListTile(
                  title: const Text("Phone Number:"),
                  subtitle: Text(room.bookerNumber),
                ),
                ListTile(
                  title: const Text("Match Start Time:"),
                  subtitle: Text(startTime),
                ),
                ListTile(
                  title: const Text("Match End Time:"),
                  subtitle: Text(endTime),
                ),
                ListTile(
                  title: const Text("Turf Address:"),
                  subtitle: Text(room.turfAddress),
                ),
                ListTile(
                  title: const Text("District:"),
                  subtitle: Text(room.district),
                ),
              ],
            ),
          ),
          room.isActive
              ? const ListTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.label_important_outline_rounded,
                        color: Colors.redAccent,
                        size: 40,
                      ),
                      SizedBox(
                        width: 240,
                        child: Text(
                            "You have to advance 200 BDT to confirm the room"),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
