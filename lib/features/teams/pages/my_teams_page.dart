import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/features/teams/widgets/myteam_listview.dart';
import 'package:turf_tracker/router/router.dart';

class MyTeamsPage extends ConsumerWidget {
  const MyTeamsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(AppRoutes.searchTeam.name);
            },
            icon: const Icon(Icons.search, color: greenColor),
          ),
        ],
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Your Teams",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),

          //** my team listview */
          MyTeamListview()
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: greenColor,
        onPressed: () {
          context.pushNamed(AppRoutes.createTeam.name);
        },
        label: const Text("Create New Team"),
      ),
    );
  }
}
