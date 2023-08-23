import 'package:flutter/material.dart';
import 'package:turf_tracker/features/rooms/pages/rooms_page.dart';
import 'package:turf_tracker/features/home/pages/homepage.dart';
import 'package:turf_tracker/features/profile/pages/profile_page.dart';
import 'package:turf_tracker/features/teams/pages/my_teams_page.dart';
import 'package:turf_tracker/features/turfs/pages/turf_page.dart';

class TabWidgets {
  static final List<Widget> tabwidgets = <Widget>[
    const HomePage(),
    const TurfPage(),
    const RoomsPage(),
    const MyTeamsPage(),
    const ProfilePage(),
  ];
}
