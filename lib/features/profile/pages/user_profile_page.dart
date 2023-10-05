import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/models/user.dart';
import '../../../models/team.dart';
import '../../teams/controller/team_controller.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  final UserModel userModel;
  const UserProfilePage({
    super.key,
    required this.userModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final UserModel user = widget.userModel;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            CachedNetworkImageProvider(user.profilePic),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                child: Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 5),
                  Text(
                    "UserId: ${user.uid}",
                    style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.5)),
                  ),
                  IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: user.uid));
                      },
                      icon: const Icon(Icons.copy)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Interested Sports",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 95,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: user.interestedSports.length,
                        itemBuilder: (context, index) {
                          final position = user.interestedSports[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: position.iconLink,
                                  height: 40,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  position.iconName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                      "${user.name}'s joined:",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 120,
                      child: ref.watch(getUserTeamsProvider(user.uid)).when(
                            data: (teams) {
                              return teams.isEmpty
                                  ? const Center(
                                      child:
                                          Text("You haven't joined Any Team"),
                                    )
                                  : ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: teams.length,
                                      itemBuilder: (context, index) {
                                        Team team = teams[index];

                                        return GestureDetector(
                                          onTap: () {},
                                          child: Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              AspectRatio(
                                                aspectRatio: 16 / 9,
                                                child: CachedNetworkImage(
                                                  imageUrl: team.teamProfile,
                                                  fit: BoxFit.fill,
                                                  color: Colors.black45,
                                                  colorBlendMode:
                                                      BlendMode.darken,
                                                ),
                                              ),
                                              Text(
                                                team.name,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                    ),
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
