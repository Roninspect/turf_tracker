// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:turf_tracker/common/show_dialog.dart';

import 'package:turf_tracker/models/team.dart';

import '../controller/team_controller.dart';

class RemoveMemberPage extends ConsumerWidget {
  final Team team;
  const RemoveMemberPage({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String membersCount = team.members.length.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "All Members ($membersCount)",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ref.watch(streamMembersFromFirestoreProvider(team.tid)).when(
                  data: (data) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final member = data[index];
                          return ref.watch(getuserByUidProvider(member)).when(
                                data: (user) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        //<-- SEE HERE
                                        side: const BorderSide(
                                            width: 1, color: Colors.white10),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(user.profilePic),
                                      ),
                                      title: Text(
                                        "${user.name} ${team.mods.contains(user.uid) ? '(moderators)' : ''}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: !team.mods.contains(user.uid)
                                          ? IconButton(
                                              onPressed: () {
                                                showAlertDialogWithConfirmation(
                                                    ifyes: "Yes",
                                                    ifNo: "No",
                                                    context: context,
                                                    message: "Are you sure?",
                                                    onLeavePressed: () {
                                                      ref
                                                          .read(
                                                              teamControllerProvider
                                                                  .notifier)
                                                          .removeMember(
                                                              teamId: team.tid,
                                                              userId: user.uid,
                                                              context: context);
                                                    });
                                              },
                                              icon: const Icon(
                                                MaterialIcons.person_remove,
                                                color: Colors.redAccent,
                                              ))
                                          : const SizedBox.shrink(),
                                    ),
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
                              );
                        },
                      ),
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
          ],
        ),
      ),
    );
  }
}
