import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/common/show_dialog.dart';
import 'package:turf_tracker/features/auth/provider/district_provider.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';
import 'package:turf_tracker/features/profile/controller/profile_controller.dart';
import 'package:turf_tracker/features/profile/widget/team_listview.dart';
import 'package:turf_tracker/features/rooms/controller/room_controller.dart';
import 'package:turf_tracker/features/root/provider/nav_controller.dart';
import '../../../common/filepicker.dart';
import '../../../router/router.dart';
import '../../turfs/provider/district_change_notifier.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  File? profile;

  void pickProfile() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profile = File(res.files.first.path!);
      });
    }
  }

  void updateProfile() {
    if (profile != null) {
      ref
          .read(profileControllerProvider.notifier)
          .changeProfile(profile: profile, context: context);
      setState(() {
        profile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataNotifierProvider);
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
                        backgroundImage: profile != null
                            ? FileImage(profile!) as ImageProvider
                            : CachedNetworkImageProvider(user.profilePic),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap:
                                  profile != null ? updateProfile : pickProfile,
                              child: profile != null
                                  ? const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.cloud_upload_sharp,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 90),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: cardColor),
                        onPressed: () =>
                            context.pushNamed(AppRoutes.bookingsHistory.name),
                        child: const Text(
                          "Bookings History",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
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
                    const Text(
                      "Your Teams",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    //** team Listview */
                    const TeamListView(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: greenColor,
                                minimumSize: const Size(150, 50)),
                            onPressed: () {
                              context.pushNamed(AppRoutes.editProfile.name,
                                  extra: user);
                            },
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(color: Colors.white),
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(150, 50)),
                            onPressed: () async {
                              showAlertDialogWithConfirmation(
                                  context: context,
                                  message: "Are you Sure?",
                                  ifyes: "Sign Out",
                                  ifNo: "No",
                                  onLeavePressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    await GoogleSignIn().signOut();
                                    ref.invalidate(userDataNotifierProvider);
                                    ref.invalidate(navNotifierProvider);
                                    ref.invalidate(
                                        districtChangeNotifierProvider);
                                    ref.invalidate(
                                        registerDistrictSelectingNotifierProvider);
                                    ref.invalidate(getMyRoomsProvider);
                                  });
                            },
                            child: const Text(
                              'Sign Out',
                              style: TextStyle(color: Colors.redAccent),
                            )),
                      ],
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
