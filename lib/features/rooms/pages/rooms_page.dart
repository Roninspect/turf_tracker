import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/features/rooms/pages/all_room_page.dart';
import 'package:turf_tracker/features/rooms/pages/inactiveRoomsPage.dart';
import 'package:turf_tracker/features/rooms/pages/my_rooms_page.dart';

import '../provider/room_page_tab_provider.dart';

class RoomPage extends ConsumerStatefulWidget {
  const RoomPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final TabController tabController = TabController(length: 3, vsync: this);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: const <TextSpan>[
                TextSpan(
                  text: 'Turf ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: greenColor,
                  ),
                ),
                TextSpan(
                  text: "Tracker",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            TabBar(
                controller: tabController,
                onTap: (value) {
                  ref
                      .read(mainroomTabIndexNotifierProvider.notifier)
                      .changeIndex(selectedValue: value);
                },
                indicatorColor: greenColor,
                splashFactory: NoSplash.splashFactory,
                tabs: const [
                  Tab(
                    icon: Text(
                      "Active Rooms",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Tab(
                    icon: Text(
                      "My Rooms",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Tab(
                    icon: Text(
                      "Joined Rooms",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ]),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  AllRoomsPage(),
                  MyRoomsPage(),
                  AllInactiveRoomsPage(),
                ],
              ),
            )
          ],
        ));
  }
}
