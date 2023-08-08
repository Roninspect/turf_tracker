// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/common/custom_snackbar.dart';
import 'package:turf_tracker/features/teams/providers/sports_icon_selected.dart';
import 'package:turf_tracker/models/icon.dart';
import 'package:turf_tracker/models/team.dart';

import '../../../common/filepicker.dart';
import '../controller/team_controller.dart';

class EditTeamPage extends ConsumerStatefulWidget {
  final Team team;
  const EditTeamPage({
    super.key,
    required this.team,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditTeamPageState();
}

class _EditTeamPageState extends ConsumerState<EditTeamPage> {
  late TextEditingController teamNameController;
  File? bannerImage;

  void pickBanner() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerImage = File(res.files.first.path!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    teamNameController = TextEditingController(text: widget.team.name);
  }

  @override
  void dispose() {
    super.dispose();
    teamNameController.dispose();
    ref.invalidate(iconsSelectedNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(teamControllerProvider);
    final selectedSports = ref.watch(iconsSelectedNotifierProvider);

    void updateTeam() {
      if (teamNameController.text.isNotEmpty && bannerImage != null) {
        ref.read(teamControllerProvider.notifier).update(
            teamName: teamNameController.text,
            teamId: widget.team.tid,
            banner: bannerImage,
            context: context,
            icons: widget.team.sportsPlays);
        context.pop();

        showSnackbar(
            context: context,
            text: "Team Updated Successfully",
            color: greenColor);
      } else if (teamNameController.text.isNotEmpty && bannerImage == null) {
        ref.read(teamControllerProvider.notifier).update(
            teamName: teamNameController.text,
            teamId: widget.team.tid,
            existingBanner: widget.team.teamProfile,
            context: context,
            icons: selectedSports);
        context.pop();

        showSnackbar(
            context: context,
            text: "Team Updated Successfully",
            color: greenColor);
      } else {
        showSnackbar(context: context, text: "please fill up all the fields");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new Team"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Update team image",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: pickBanner,
                  child: DottedBorder(
                      dashPattern: const [5, 1],
                      color: Colors.white,
                      child: bannerImage != null
                          ? AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.file(
                                bannerImage!,
                                fit: BoxFit.fill,
                              ))
                          : Image.network(widget.team.teamProfile)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Update your team name",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: teamNameController,
                maxLength: 25,
                decoration: const InputDecoration(
                  hintText: "Team Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Sports you guys already play:",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 128,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.team.sportsPlays.length,
                  itemBuilder: (context, index) {
                    final singleSport = widget.team.sportsPlays[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: selectedSports.contains(singleSport)
                                ? greenColor
                                : const Color.fromRGBO(0, 0, 0, 0)),
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
                      ),
                    );
                  },
                ),
              ),
              const Text(
                "What kind sports you guys play? (select one or multiple spots)",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 128,
                child: ref.watch(getsportsIconsProvider).when(
                      data: (icons) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: icons.length,
                          itemBuilder: (context, index) {
                            final singleSport = icons[index];

                            final isTimeSelected =
                                selectedSports.contains(singleSport);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (isTimeSelected) {
                                    ref
                                        .read(iconsSelectedNotifierProvider
                                            .notifier)
                                        .removeSelectedSport(
                                            iconModel: singleSport);
                                  } else {
                                    ref
                                        .read(iconsSelectedNotifierProvider
                                            .notifier)
                                        .addSports(iconModel: singleSport);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: selectedSports
                                              .contains(singleSport)
                                          ? greenColor
                                          : const Color.fromRGBO(0, 0, 0, 0)),
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
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      maximumSize: const Size(200, 50),
                      minimumSize: const Size(200, 50)),
                  onPressed: updateTeam,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
