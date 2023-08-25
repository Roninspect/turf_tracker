// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/models/room.dart';

class AcceptedByPage extends ConsumerWidget {
  final Room room;
  const AcceptedByPage({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 16 / 9),
              children: [
                ListTile(
                  title: const Text("Accepted By:"),
                  subtitle: Text(room.joinedByName),
                ),
                ListTile(
                  title: const Text("Phone Number:"),
                  subtitle: Text(room.joinedByNumber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
