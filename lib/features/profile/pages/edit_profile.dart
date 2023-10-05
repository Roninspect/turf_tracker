// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/common/custom_snackbar.dart';
import 'package:turf_tracker/features/profile/controller/profile_controller.dart';
import 'package:turf_tracker/models/user.dart';
import '../../../common/colors.dart';
import '../../auth/provider/district_provider.dart';
import '../../teams/controller/team_controller.dart';
import '../provider/sports_selection_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final UserModel user;
  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController phoneNumberController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.user.name);
    phoneNumberController =
        TextEditingController(text: widget.user.phoneNumber);
    addressController = TextEditingController(text: widget.user.address);
  }

  @override
  Widget build(BuildContext context) {
    final selectedSports = ref.watch(updateSportsNotifierProvider);
    final String selectedDistrict =
        ref.watch(registerDistrictSelectingNotifierProvider);
    final isLoading = ref.watch(profileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "UserName",
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 05),
              TextField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                controller: usernameController,
              ),
              const SizedBox(height: 10),
              const Text(
                "Address",
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 05),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white10)),
                  hintText: "Address",
                ),
                controller: addressController,
              ),
              const SizedBox(height: 10),
              const Text(
                "Phone Number",
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 05),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Phone Number",
                ),
                controller: phoneNumberController,
              ),
              const SizedBox(height: 20),
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

                            final isTimeSelected = selectedSports.any((sport) =>
                                sport.iconName == singleSport.iconName);

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (isTimeSelected) {
                                    ref
                                        .read(updateSportsNotifierProvider
                                            .notifier)
                                        .removeSports(singleSport: singleSport);
                                  } else {
                                    ref
                                        .read(updateSportsNotifierProvider
                                            .notifier)
                                        .updateSports(singleSport: singleSport);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: isTimeSelected
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
              const Text(
                "Update your district)",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              DropdownButton(
                borderRadius: BorderRadius.circular(20),
                value: selectedDistrict,
                items: const [
                  DropdownMenuItem(value: "Dhaka", child: Text("Dhaka")),
                  DropdownMenuItem(
                      value: "Chittagong", child: Text("Chittagong")),
                ],
                onChanged: (value) {
                  ref
                      .read(registerDistrictSelectingNotifierProvider.notifier)
                      .changeDistrict(selectedDistrict: value!);
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      maximumSize: const Size(200, 50),
                      minimumSize: const Size(200, 50)),
                  onPressed: () {
                    if (phoneNumberController.text.length >= 11) {
                      ref
                          .read(profileControllerProvider.notifier)
                          .updateProfile(
                              userName: usernameController.text,
                              address: addressController.text,
                              phoneNumber: phoneNumberController.text,
                              selectedDistrict: selectedDistrict,
                              context: context,
                              selectedSports: selectedSports);
                      context.pop();
                    } else {
                      showSnackbar(
                          color: Colors.redAccent,
                          context: context,
                          text: "Add a valid Phone Number");
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.black,
                        )
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
            ],
          ),
        ),
      ),
    );
  }
}
