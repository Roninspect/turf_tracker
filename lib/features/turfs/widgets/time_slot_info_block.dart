// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeSlotInfoBlock extends ConsumerWidget {
  final Color? borderColor;
  final Color backgroundColor;
  final String text;
  const TimeSlotInfoBlock({
    super.key,
    this.borderColor,
    required this.backgroundColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        CircleAvatar(
          radius: 11,
          backgroundColor: borderColor ?? const Color.fromRGBO(0, 0, 0, 0),
          child: CircleAvatar(
            radius: 10,
            backgroundColor: backgroundColor,
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(width: 90, child: Text(text))
      ],
    );
  }
}
