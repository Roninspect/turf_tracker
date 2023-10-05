// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:turf_tracker/models/team.dart';

import '../../../router/router.dart';
import '../controller/team_controller.dart';

class ModsPage extends ConsumerWidget {
  final Team team;
  const ModsPage({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String modsCount = team.mods.length.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //** mods List */
            Text(
              "All Mods ($modsCount)",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: team.mods.length,
                itemBuilder: (context, index) {
                  final mod = team.mods[index];
                  return ref.watch(getuserByUidProvider(mod)).when(
                        data: (user) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () => context.pushNamed(
                                  AppRoutes.userProfile.name,
                                  pathParameters: {
                                    "teamId": team.tid,
                                    'id': mod
                                  },
                                  extra: user),
                              shape: RoundedRectangleBorder(
                                //<-- SEE HERE
                                side: const BorderSide(
                                    width: 1, color: Colors.white10),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              leading: Text(
                                '${index + 1}.',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              trailing: CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                              ),
                              title: Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
