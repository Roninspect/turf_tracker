import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';
import 'package:turf_tracker/features/home/widgets/favorite_turf_listview.dart';
import 'package:turf_tracker/features/home/widgets/upcoming_list_view.dart';
import 'package:turf_tracker/router/router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    ref.read(userDataNotifierProvider.notifier).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataNotifierProvider);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: backgroundColor,
          toolbarHeight: 80,
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
          actions: [
            Row(
              children: [
                const Icon(
                  Fontisto.map_marker_alt,
                  color: greenColor,
                ),
                const SizedBox(width: 10),
                Text(user.district),
                const SizedBox(width: 10),
              ],
            ),
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //** upcoming matches Listview */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Upcoming",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () =>
                          context.pushNamed(AppRoutes.upcomingBookings.name),
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          color: greenColor,
                        ),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              const UpcomingMatches(),
              const SizedBox(height: 20),

              //** favorite turfs Listview */
              const Text(
                "Your favorites",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const FavoriteTurfListView(),
            ],
          ),
        ),
      ),
    );
  }
}
