import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/features/bookings/pages/past_bookings.dart';
import 'package:turf_tracker/features/bookings/pages/upcoming_page.dart';

class BookingPage extends ConsumerWidget {
  const BookingPage({super.key});

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
          length: 2,
          child: Column(
            children: [
              TabBar(
                indicatorColor: greenColor,
                splashFactory: NoSplash.splashFactory,
                tabs: [
                  Tab(
                    icon: Text(
                      "Upcoming",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Tab(
                    icon: Text(
                      "Past",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  UpComingPage(),
                  PastBookingsPage(),
                ]),
              ),
            ],
          )),
    );
  }
}
