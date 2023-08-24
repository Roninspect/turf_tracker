import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/features/rooms/pages/all_room_page.dart';
import 'package:turf_tracker/features/rooms/pages/inactiveRoomsPage.dart';
import 'package:turf_tracker/features/rooms/pages/my_rooms_page.dart';

class RoomsPage extends ConsumerWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        body: const DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                    indicatorColor: greenColor,
                    splashFactory: NoSplash.splashFactory,
                    tabs: [
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
                  child: TabBarView(children: [
                    AllRoomsPage(),
                    MyRoomsPage(),
                    AllInactiveRoomsPage(),
                  ]),
                )
              ],
            )));
  }
}
