// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:turf_tracker/models/team.dart';

import '../../../router/router.dart';

class ModToolsPage extends ConsumerWidget {
  final Team team;
  const ModToolsPage({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mod Tools"),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              context.pushNamed(
                AppRoutes.addMods.name,
                pathParameters: {
                  "teamId": team.tid,
                },
                extra: team,
              );
            },
            leading: const Icon(MaterialIcons.add_moderator),
            title: const Text(
              "Add or Remove Mods",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              context.pushNamed(
                AppRoutes.editTeam.name,
                pathParameters: {
                  "teamId": team.tid,
                },
                extra: team,
              );
            },
            leading: const Icon(MaterialIcons.edit),
            title: Text(
              "Edit ${team.name}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              context.pushNamed(
                AppRoutes.removeMember.name,
                pathParameters: {
                  "teamId": team.tid,
                },
                extra: team,
              );
            },
            leading: const Icon(MaterialIcons.person_remove),
            title: const Text(
              "Remove Members",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
