import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/common/tab_widgets.dart';
import '../provider/nav_controller.dart';

class RootPage extends ConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.watch(navNotifierProvider);
    return Scaffold(
      body: TabWidgets.tabwidgets[nav],
      bottomNavigationBar: Container(
        color: backgroundColor,
        height: 85,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: backgroundColor,
            tabBackgroundColor: greenColor,
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.all(10),
            tabActiveBorder: Border.all(width: 2),
            gap: 10,
            tabs: const [
              GButton(
                icon: FontAwesome.home,
                text: "Home",
              ),
              GButton(
                icon: MaterialCommunityIcons.soccer_field,
                text: "Turfs",
              ),
              GButton(
                icon: MaterialCommunityIcons.google_controller,
                text: "Rooms",
              ),
              GButton(
                icon: MaterialIcons.groups,
                text: "Teams",
              ),
              GButton(
                icon: Octicons.person,
                text: "Profile",
              ),
            ],
            selectedIndex: nav,
            onTabChange: (value) {
              ref.read(navNotifierProvider.notifier).navStateChange(value);
            },
          ),
        ),
      ),
    );
  }
}
