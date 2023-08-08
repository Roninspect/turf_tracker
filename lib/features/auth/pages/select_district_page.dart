import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/auth/controller/auth_controller.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';
import 'package:turf_tracker/models/user.dart';

import '../../../common/colors.dart';
import '../provider/district_provider.dart';

class SelectDistrictPage extends ConsumerWidget {
  const SelectDistrictPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataNotifierProvider);
    final String selectedDistrict =
        ref.watch(registerDistrictSelectingNotifierProvider);
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
                borderRadius:
                    BorderRadius.circular(8.0), // Set the border radius
              ),
              child: DropdownButton(
                padding: const EdgeInsets.all(20),
                borderRadius: BorderRadius.circular(20),
                value: selectedDistrict,
                underline: const SizedBox.shrink(),
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
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 60),
                    backgroundColor: Colors.black),
                onPressed: () {
                  ref.read(authControllerProvider.notifier).updateTheDistrict(
                      withUpadatedUserModel: UserModel(
                          uid: user.uid,
                          name: user.name,
                          phoneNumber: user.phoneNumber,
                          address: user.address,
                          district: selectedDistrict,
                          profilePic: user.profilePic,
                          rewardsPoint: user.rewardsPoint,
                          interestedSports: user.interestedSports,
                          email: user.email,
                          hasGivenReview: user.hasGivenReview,
                          bookingsNo: user.bookingsNo),
                      context: context);
                },
                child: const Text(
                  "Done",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: greenColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
