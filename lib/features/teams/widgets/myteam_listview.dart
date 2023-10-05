import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/colors.dart';
import '../../../models/team.dart';
import '../../../router/router.dart';
import '../../auth/provider/user_data_notifer.dart';
import '../controller/team_controller.dart';

class MyTeamListview extends ConsumerWidget {
  const MyTeamListview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid =
        ref.watch(userDataNotifierProvider.select((value) => value.uid));
    return Expanded(
      child: ref.watch(getUserTeamsProvider(uid)).when(
            data: (teams) {
              return teams.isEmpty
                  ? const Center(
                      child: Text("You haven't joined Any Team"),
                    )
                  : ListView.builder(
                      itemCount: teams.length,
                      itemBuilder: (context, index) {
                        Team team = teams[index];
                        String membersCount =
                            team.members.length.toString().padLeft(2, '0');

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0)
                              .copyWith(bottom: 8),
                          child: GestureDetector(
                            onTap: () {
                              context.pushNamed(AppRoutes.teamDetails.name,
                                  pathParameters: {
                                    "teamId": team.tid,
                                  },
                                  extra: team);
                            },
                            child: Container(
                              height: 325,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: team.teamProfile,
                                          fit: BoxFit.fill,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(7)
                                        .copyWith(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          team.name,
                                          style: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "Members: $membersCount",
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: greenColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider()
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
            },
            error: (error, stackTrace) {
              if (kDebugMode) {
                print(stackTrace);
              }
              return Center(
                child: Text(error.toString()),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
