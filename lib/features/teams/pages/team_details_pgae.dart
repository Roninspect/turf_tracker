// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/common/show_dialog.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';
import 'package:turf_tracker/features/teams/controller/team_controller.dart';

import 'package:turf_tracker/models/team.dart';
import 'package:turf_tracker/router/router.dart';

class TeamDetailsPage extends ConsumerWidget {
  final Team team;
  final String teamId;
  const TeamDetailsPage({
    super.key,
    required this.team,
    required this.teamId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataNotifierProvider);
    String membersCount = team.members.length.toString().padLeft(2, '0');
    String modsCount = team.mods.length.toString().padLeft(2, '0');
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Column(
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    team.teamProfile,
                    fit: BoxFit.fill,
                  )),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 250,
                          child: Text(team.name,
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        team.members.contains(user.uid)
                            ? team.mods.contains(user.uid)
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: greenColor,
                                        minimumSize: const Size(120, 40)),
                                    onPressed: () {
                                      context.pushNamed(
                                        AppRoutes.modTools.name,
                                        pathParameters: {
                                          "teamId": teamId,
                                        },
                                        extra: team,
                                      );
                                    },
                                    child: const Text(
                                      "Mod Tools",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: greenColor,
                                    ),
                                    onPressed: () {
                                      showAlertDialogWithConfirmation(
                                          ifNo: "Stay",
                                          ifyes: "Leave",
                                          context: context,
                                          onLeavePressed: () {
                                            ref
                                                .read(teamControllerProvider
                                                    .notifier)
                                                .joiningAndLeavingTeam(
                                                    team, context);
                                          },
                                          message: "Are you sure? ");
                                    },
                                    child: const Text(
                                      "Joined",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: greenColor,
                                ),
                                onPressed: () {
                                  ref
                                      .read(teamControllerProvider.notifier)
                                      .joiningAndLeavingTeam(team, context);
                                },
                                child: const Text(
                                  "Join",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              AppRoutes.members.name,
                              pathParameters: {
                                "teamId": teamId,
                              },
                              extra: team,
                            );
                          },
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Card(
                              color: greenColor,
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Members",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    membersCount,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              AppRoutes.mods.name,
                              pathParameters: {
                                "teamId": teamId,
                              },
                              extra: team,
                            );
                          },
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Card(
                              color: greenColor,
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Mods",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    modsCount,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Interested Sports",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 95,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: team.sportsPlays.length,
                        itemBuilder: (context, index) {
                          final singleSport = team.sportsPlays[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: singleSport.iconLink,
                                  height: 40,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  singleSport.iconName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "(${singleSport.iconName})",
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                color: Colors.redAccent,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: 300,
                      child: Text(
                        "More exciting features coming soon...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
