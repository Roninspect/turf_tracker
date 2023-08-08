import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/profile/repository/profile_repository.dart';

import '../../../common/custom_snackbar.dart';
import '../../../common/storage_provider.dart';

import '../../../models/icon.dart';
import '../../../models/user.dart';
import '../../auth/provider/user_data_notifer.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, bool>((ref) {
  return ProfileController(
      profileRepository: ref.watch(profileRepositoryProvider),
      storageRepository: ref.watch(storageRepositoryProvider),
      ref: ref);
});

class ProfileController extends StateNotifier<bool> {
  final ProfileRepository _profileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  ProfileController({
    required ProfileRepository profileRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _profileRepository = profileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void changeProfile(
      {required File? profile, required BuildContext context}) async {
    state = false;
    UserModel user = _ref.watch(userDataNotifierProvider);
    String profilepic = "";
    if (profile != null) {
      state = true;
      final res = await _storageRepository.storeFile(
        path: "users/profile",
        id: user.name,
        file: profile,
      );
      state = false;
      res.fold((l) => showSnackbar(context: context, text: l.toString()), (r) {
        user = user.copyWith(profilePic: r);
        profilepic = r;
      });
    }
    state = true;
    final res = await _profileRepository.editProfile(user);

    res.fold(
      (l) => showSnackbar(context: context, text: l.message),
      (r) async {
        showSnackbar(
            context: context,
            text:
                'Profile Updated Successfully, It may take some time to show');
        _ref
            .read(userDataNotifierProvider.notifier)
            .updateProfile(profileLink: profilepic);
      },
    );
  }

  void updateProfile({
    required String? userName,
    required String? address,
    required String? phoneNumber,
    required String? selectedDistrict,
    required BuildContext context,
    required List<IconModel>? selectedSports,
  }) async {
    state = true;
    UserModel user = _ref.watch(userDataNotifierProvider);

    final newModel = user.copyWith(
      name: userName,
      address: address,
      phoneNumber: phoneNumber,
      district: selectedDistrict,
      interestedSports: selectedSports,
    );

    final res = await _profileRepository.editProfile(newModel);
    state = false;
    res.fold(
        (l) => showSnackbar(context: context, text: l.message),
        (r) => showSnackbar(
            context: context,
            text: "Updated Successfully, Reopen the app to see the changes"));
  }
}
