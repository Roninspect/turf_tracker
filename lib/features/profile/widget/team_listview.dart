import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/features/teams/controller/team_controller.dart';

import '../../../models/team.dart';
import '../../../router/router.dart';
import '../../auth/provider/user_data_notifer.dart';

class TeamListView extends ConsumerWidget {
  const TeamListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataNotifierProvider);
    return SizedBox(
      height: 120,
      child: ref.watch(getUserTeamsProvider(user.uid)).when(
            data: (teams) {
              return teams.isEmpty
                  ? const Center(
                      child: Text("You haven't joined Any Team"),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: teams.length,
                      itemBuilder: (context, index) {
                        Team team = teams[index];

                        return GestureDetector(
                          onTap: () {
                            context.pushNamed(AppRoutes.teamDetails.name,
                                pathParameters: {
                                  "teamId": team.tid,
                                },
                                extra: team);
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: CachedNetworkImage(
                                  imageUrl: team.teamProfile,
                                  fit: BoxFit.fill,
                                  color: Colors.black45,
                                  colorBlendMode: BlendMode.darken,
                                ),
                              ),
                              Text(
                                team.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 8);
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
