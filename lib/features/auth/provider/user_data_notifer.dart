import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user.dart';
import '../controller/auth_controller.dart';

final userDataNotifierProvider =
    StateNotifierProvider<UserDataNotifier, UserModel>((ref) {
  return UserDataNotifier(ref);
});

class UserDataNotifier extends StateNotifier<UserModel> {
  UserDataNotifier(this.ref)
      : super(UserModel(
            email: "loading",
            name: "loading",
            phoneNumber: "loading",
            address: "loading",
            district: "Chittagong",
            interestedSports: [],
            profilePic: "loading",
            rewardsPoint: 0,
            bookingsNo: 0,
            uid: "loading",
            hasGivenReview: true)) {
    fetchData();
  }

  final Ref ref;

  void fetchData() {
    ref.watch(userProvider).when(
          data: (data) {
            state = data;
          },
          error: (error, stackTrace) {
            return UserModel(
                email: "$error",
                name: "$error",
                phoneNumber: "error",
                address: "error",
                district: "error",
                interestedSports: [],
                profilePic: "error",
                bookingsNo: 0,
                rewardsPoint: 0,
                uid: "error",
                hasGivenReview: true);
          },
          loading: () => UserModel(
              email: "loadingg",
              name: "loadingg",
              phoneNumber: "loadingg",
              address: "loadingg",
              district: "loadingg",
              interestedSports: [],
              profilePic: "loadingg",
              rewardsPoint: 0,
              bookingsNo: 0,
              uid: "loadingg",
              hasGivenReview: true),
        );
  }

  void updateProfile({required String profileLink}) {
    state.profilePic = profileLink;
  }
}
