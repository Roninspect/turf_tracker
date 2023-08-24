import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmRoomPage extends ConsumerWidget {
  const ConfirmRoomPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Frenzy Arena"),
      ),
      body: const Column(
        children: [
          Row(
            children: [
              Text("Booked By:"),
              Text("Ronin Spect"),
            ],
          ),
          Row(
            children: [
              Text("Booked By:"),
              Text("Ronin Spect"),
            ],
          ),
          Row(
            children: [
              Text("Booked By:"),
              Text("Ronin Spect"),
            ],
          ),
          Row(
            children: [
              Text("Booked By:"),
              Text("Ronin Spect"),
            ],
          ),
          Row(
            children: [
              Text("Booked By:"),
              Text("Ronin Spect"),
            ],
          ),
        ],
      ),
    );
  }
}
