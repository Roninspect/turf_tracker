import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/features/teams/controller/team_controller.dart';

import 'package:turf_tracker/features/teams/pages/search_team_page.dart';
import 'package:turf_tracker/models/team.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Your Teams",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ref.watch(getUserTeamsProvider).when(
                  data: (teams) {
                    return teams.isEmpty
                        ? const Center(
                            child: Text("You haven't joined Any Team"),
                          )
                        : ListView.builder(
                            itemCount: teams.length,
                            itemBuilder: (context, index) {
                              Team team = teams[index];
                              String membersCount = team.members.length
                                  .toString()
                                  .padLeft(2, '0');

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0)
                                        .copyWith(bottom: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                        AppRoutes.teamDetails.name,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                team.teamProfile,
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
                                        Divider()
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
          )
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
// Stack(
//                                     alignment: Alignment.bottomCenter,
//                                     children: [
//                                       AspectRatio(
//                                         aspectRatio: 16 / 9,
//                                         child: CachedNetworkImage(
//                                           width: 400,
//                                           imageUrl: team.teamProfile,
//                                           color: Colors.black54,
//                                           colorBlendMode: BlendMode.darken,
//                                           height: 200,
//                                           fit: BoxFit.fill,
//                                         ),
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: [
//                                           SizedBox(
//                                             width: 200,
//                                             child: Text(
//                                               team.name,
//                                               style: const TextStyle(
//                                                 fontSize: 50,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           Text(
//                                             "Members: $membersCount",
//                                             style: const TextStyle(
//                                               fontSize: 20,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Positioned(
//                                         top:
//                                             10, // Adjust this value to change the vertical position of the button
//                                         right:
//                                             10, // Adjust this value to change the horizontal position of the button
//                                         child: IconButton(
//                                             onPressed: () {
//                                               // Handle the button's onPressed event
//                                             },
//                                             icon: const Icon(
//                                               Icons.favorite,
//                                               size: 30,
//                                             )),
//                                       ),
//                                     ],
//                                   ),