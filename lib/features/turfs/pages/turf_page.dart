import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/features/turfs/provider/district_change_notifier.dart';
import 'package:turf_tracker/features/turfs/widgets/turfs_listview.dart';
import 'package:turf_tracker/router/router.dart';
import '../../../models/user.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/provider/district_provider.dart';
import '../../auth/provider/user_data_notifer.dart';
import '../../auth/repository/auth_repository.dart';

class TurfPage extends ConsumerWidget {
  const TurfPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //** for main turf page */
    final String? selectedDistrict = ref.watch(districtChangeNotifierProvider);
    final user = ref.watch(userDataNotifierProvider);

    //** for veriying district page */
    final changeDistrict = ref.watch(registerDistrictSelectingNotifierProvider);
    final isLoading = ref.watch(authControllerProvider);

    return ref.watch(hasUserSelectedDistrictProvider).when(
          data: (data) {
            if (data.district.isNotEmpty && selectedDistrict!.isNotEmpty) {
              //** main turf page */

              return Scaffold(
                backgroundColor: backgroundColor,
                appBar: AppBar(
                  backgroundColor: backgroundColor,
                  toolbarHeight: 100,
                  leading: const Icon(
                    Fontisto.map_marker_alt,
                    color: greenColor,
                  ),
                  title: user.address.isEmpty
                      ? TextButton(
                          onPressed: () {
                            context.pushNamed(AppRoutes.editProfile.name,
                                extra: user);
                          },
                          child: const Text(
                            "Please add your address",
                            style: TextStyle(color: Colors.red),
                          ))
                      : Text(user.address),
                  actions: [
                    DropdownButton<String>(
                      value: selectedDistrict.isNotEmpty
                          ? selectedDistrict
                          : changeDistrict,
                      items: const [
                        DropdownMenuItem(value: "Dhaka", child: Text("Dhaka")),
                        DropdownMenuItem(
                            value: "Chittagong", child: Text("Chittagong")),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(districtChangeNotifierProvider.notifier)
                              .fetchDiferentDistrict(selectedDistrict: value);
                        }
                      },
                    ),
                  ],
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text(
                        "Turfs in $selectedDistrict",
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),

                    //** main turf Listview */
                    const Expanded(
                      child: TurfsListView(),
                    ),
                  ],
                ),
              );
            } else {
              //** verify district page */

              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Please Select Your District",
                        style: TextStyle(fontSize: 25),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white10, // Set the border color
                            width: 1.0, // Set the border width
                          ),
                          borderRadius: BorderRadius.circular(
                              8.0), // Set the border radius
                        ),
                        child: DropdownButton<String>(
                          padding: const EdgeInsets.all(20),
                          borderRadius: BorderRadius.circular(20),
                          value: changeDistrict.isNotEmpty
                              ? changeDistrict
                              : "Chittagong",
                          underline: const SizedBox.shrink(),
                          items: const [
                            DropdownMenuItem<String>(
                                value: "Dhaka", child: Text("Dhaka")),
                            DropdownMenuItem<String>(
                                value: "Chittagong", child: Text("Chittagong")),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              ref
                                  .read(
                                      registerDistrictSelectingNotifierProvider
                                          .notifier)
                                  .changeDistrict(selectedDistrict: value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(250, 60),
                              backgroundColor: Colors.black),
                          onPressed: () async {
                            ref
                                .read(districtChangeNotifierProvider.notifier)
                                .fetchDiferentDistrict(
                                    selectedDistrict: changeDistrict);
                            ref
                                .read(authControllerProvider.notifier)
                                .updateTheDistrict(
                                    withUpadatedUserModel: UserModel(
                                        uid: user.uid,
                                        name: user.name,
                                        phoneNumber: user.phoneNumber,
                                        address: user.address,
                                        district: changeDistrict,
                                        profilePic: user.profilePic,
                                        rewardsPoint: user.rewardsPoint,
                                        interestedSports: user.interestedSports,
                                        email: user.email,
                                        bookingsNo: user.bookingsNo,
                                        hasGivenReview: user.hasGivenReview,
                                        hasClosed: user.hasClosed,
                                        hasGivenFeedback:
                                            user.hasGivenFeedback),
                                    context: context);

                            ref.read(userDataNotifierProvider);
                          },
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Done",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: greenColor),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
