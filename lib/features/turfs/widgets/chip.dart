// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/common/colors.dart';

class CustomChip extends ConsumerWidget {
  final String first;
  final String? second;
  final IconData icon;
  const CustomChip({
    super.key,
    required this.first,
    required this.icon,
    this.second,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        padding: EdgeInsets.all(10),
        side: BorderSide.none,
        avatar: Icon(
          icon,
          color: greenColor,
        ),
        label: Row(
          children: [
            Text(first),
            if (second != null)
              Text("-$second"), // Conditionally show the second text
          ],
        ),
      ),
    );
  }
}
