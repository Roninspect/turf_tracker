import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/rooms/widgets/rooms_block.dart';

class AllRoomsPage extends ConsumerWidget {
  const AllRoomsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: RoomsCard(),
    );
  }
}
