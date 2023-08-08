// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/features/root/provider/nav_controller.dart';
import 'package:uuid/uuid.dart';

import 'package:turf_tracker/features/teams/repository/team_repository.dart';

import '../../../common/custom_snackbar.dart';
import '../../../common/failure.dart';
import '../../../common/storage_provider.dart';
import '../../../common/typedefs.dart';
import '../../../models/icon.dart';
import '../../../models/team.dart';
import '../../../models/user.dart';
import '../../auth/provider/user_data_notifer.dart';
import '../providers/search_products_provider.dart';

final teamControllerProvider =
    StateNotifierProvider<TeamController, bool>((ref) {
  return TeamController(
      ref: ref,
      storageRepository: ref.watch(storageRepositoryProvider),
      teamRepository: ref.watch(teamRepositoryProvider));
});

final getUserTeamsProvider = StreamProvider<List<Team>>((ref) {
  return ref.watch(teamControllerProvider.notifier).getUserTeams();
});

final getuserByUidProvider =
    StreamProvider.family.autoDispose<UserModel, String>((ref, uid) {
  return ref.watch(teamControllerProvider.notifier).getuserByUid(uid: uid);
});

final getsportsIconsProvider =
    StreamProvider.autoDispose<List<IconModel>>((ref) {
  return ref.watch(teamControllerProvider.notifier).getsportsIcons();
});

final streamMembersFromFirestoreProvider =
    StreamProvider.family.autoDispose<List<dynamic>, String>((ref, teamId) {
  return ref
      .watch(teamControllerProvider.notifier)
      .streamMembersFromFirestore(teamId);
});

//* searching for a community
final searchTeamProvider = FutureProvider.family.autoDispose(
    (ref, String query) =>
        ref.watch(teamControllerProvider.notifier).searchTeam(query));

class TeamController extends StateNotifier<bool> {
  final TeamRepository teamRepository;
  final StorageRepository storageRepository;
  final Ref ref;

  TeamController({
    required this.teamRepository,
    required this.storageRepository,
    required this.ref,
  }) : super(false);

//** getting all my teams */
  Stream<List<Team>> getUserTeams() {
    final uid =
        ref.watch(userDataNotifierProvider.select((value) => value.uid));
    return teamRepository.getUserTeams(uid: uid);
  }

//** getting all my teams */
  Stream<UserModel> getuserByUid({required String uid}) {
    return teamRepository.getuserByUid(uid: uid);
  }

  //** Creating a new Team */

  void createTeam({
    required String teamName,
    required File? banner,
    required BuildContext context,
    required List<IconModel> icons,
  }) async {
    state = true;
    final tid = const Uuid().v1();
    String bannerPic = "";
    if (banner != null) {
      state = true;
      final res = await storageRepository.storeFile(
        path: "teams/profile",
        id: tid,
        file: banner,
      );
      state = false;
      res.fold((l) => showSnackbar(context: context, text: l.toString()), (r) {
        bannerPic = r;
      });
    }
    String uid =
        ref.watch(userDataNotifierProvider.select((value) => value.uid));

    Team team = Team(
        tid: tid,
        name: teamName,
        nameInLowerCase: teamName.toLowerCase(),
        teamProfile: bannerPic,
        members: [uid],
        mods: [uid],
        sportsPlays: icons);
    print('Team: ${team.toMap()}');
    state = false;
    final res = await teamRepository.createTeam(teamModel: team);

    res.fold(
      (l) => showSnackbar(context: context, text: l.message),
      (r) => context.pop(),
    );
  }

  void update({
    required String teamName,
    File? banner,
    String? existingBanner,
    required String teamId,
    required BuildContext context,
    required List<IconModel> icons,
  }) async {
    state = true;

    String bannerPic = "";
    if (banner != null) {
      state = true;
      final res = await storageRepository.storeFile(
        path: "teams/profile",
        id: teamId,
        file: banner,
      );
      state = false;
      res.fold((l) => showSnackbar(context: context, text: l.toString()), (r) {
        bannerPic = r;
      });
    } else {
      bannerPic = existingBanner!;
    }
    final uid =
        ref.watch(userDataNotifierProvider.select((value) => value.uid));

    Team team = Team(
        tid: teamId,
        name: teamName,
        nameInLowerCase: teamName.toLowerCase(),
        teamProfile: bannerPic,
        members: [uid],
        mods: [uid],
        sportsPlays: icons);
    print('Team: ${team.toMap()}');
    state = false;
    final res = await teamRepository.createTeam(teamModel: team);

    res.fold(
      (l) => showSnackbar(context: context, text: l.message),
      (r) => context.pop(),
    );
  }

  //*** adding or removing mod */
  void addMod(
      {required String teamId,
      required List mods,
      required BuildContext context}) async {
    state = true;
    final res = await teamRepository.addMod(teamid: teamId, mods: mods);
    state = false;
    res.fold(
        (l) => showSnackbar(context: context, text: l.message),
        (r) => showSnackbar(
              context: context,
              text: "Mods successfully updates",
            ));
  }

  Stream<List<IconModel>> getsportsIcons() {
    return teamRepository.getsportsIcons();
  }

  //* searching community
  Future<List<Team>> searchTeam(String query) {
    return teamRepository.searchTeam(query);
  }

  //* joining and leaving a community
  void joiningAndLeavingTeam(Team team, BuildContext context) async {
    Either<Failure, void> res;
    final user = ref.watch(userDataNotifierProvider);
    if (team.members.contains(user.uid)) {
      res =
          await teamRepository.leaveMember(teamId: team.tid, userId: user.uid);
    } else {
      res = await teamRepository.addMember(teamId: team.tid, userId: user.uid);
    }
    res.fold((l) => showSnackbar(context: context, text: l.message), (r) {
      if (team.members.contains(user.uid)) {
        showSnackbar(context: context, text: "left community successfully");
        context.pop();
      } else {
        showSnackbar(
            context: context,
            text: "Joined community successfully",
            color: greenColor);
        context.pop();
        context.pop();
        ref.invalidate(searchedTeamNotifierProvider);
        ref.read(navNotifierProvider.notifier).navStateChange(3);
      }
    });
  }

  void removeMember(
      {required String teamId,
      required String userId,
      required BuildContext context}) async {
    final res =
        await teamRepository.leaveMember(teamId: teamId, userId: userId);

    res.fold(
      (l) => showSnackbar(context: context, text: l.message),
      (r) => showSnackbar(
          context: context,
          text:
              "Member removes succesfully, this may take some time to take effect"),
    );
  }

  Stream<List<dynamic>> streamMembersFromFirestore(String teamId) {
    return teamRepository.streamMembersFromFirestore(teamId);
  }
}
