import 'package:flutter/material.dart';
import 'package:turf_tracker/features/turfs/widgets/time_slot_info_block.dart';

import '../../../common/colors.dart';

Future<void> timeslotdialog({required BuildContext context}) async {
  await showDialog(
    context: context,
    builder: (context) => const AlertDialog(
      backgroundColor: backgroundColor,
      content: SizedBox(
        height: 280,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("What is the colors in the time slot?"),
            TimeSlotInfoBlock(
              text: "available",
              backgroundColor: backgroundColor,
              borderColor: greenColor,
            ),
            TimeSlotInfoBlock(
              text: "You selected a slot",
              backgroundColor: greenColor,
            ),
            TimeSlotInfoBlock(
              text: "Booked",
              backgroundColor: Colors.red,
            ),
            TimeSlotInfoBlock(
              text: "Not booked but someone is considering",
              backgroundColor: lockedColor,
            ),
          ],
        ),
      ),
    ),
  );
}
