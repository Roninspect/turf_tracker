// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/teams/controller/team_controller.dart';

import 'package:turf_tracker/models/team.dart';

import '../../../common/error_text.dart';

class AddModPage extends ConsumerStatefulWidget {
  final Team team;
  const AddModPage({
    super.key,
    required this.team,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModPageState();
}

class _AddModPageState extends ConsumerState<AddModPage> {
  void removeMod(String uid) {
    setState(() {
      widget.team.mods.remove(uid);
    });
  }

  void addMod(String uid) {
    setState(() {
      widget.team.mods.add(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(teamControllerProvider);
    Set<String> mods = {};

    Set<String> addedMods = {};
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add or Remove Mods"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(teamControllerProvider.notifier).addMod(
                  teamId: widget.team.tid,
                  mods: mods.toList(),
                  context: context);
            },
            icon: isLoading
                ? const CircularProgressIndicator()
                : const Icon(Icons.done),
          ),
        ],
      ),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Moderators"),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: widget.team.mods.length,
              itemBuilder: (context, index) {
                final moderators = widget.team.mods[index];
                return ref.watch(getuserByUidProvider(moderators)).when(
                      data: (user) {
                        if (widget.team.mods.contains(moderators) &&
                            !addedMods.contains(moderators)) {
                          mods.add(moderators);
                          addedMods.add(moderators);
                        }

                        return CheckboxListTile(
                          title: Text(user.name),
                          value: mods.contains(moderators),
                          onChanged: (val) {
                            if (val!) {
                              addMod(user.uid);
                            } else {
                              removeMod(user.uid);
                            }
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const CircularProgressIndicator(),
                    );
              }),
        ),
        const Text("All members"),
        Expanded(
          child: ListView.builder(
              itemCount: widget.team.members.length,
              itemBuilder: (context, index) {
                final member = widget.team.members[index];
                return ref.watch(getuserByUidProvider(member)).when(
                      data: (user) {
                        if (widget.team.mods.contains(member) &&
                            !addedMods.contains(member)) {
                          mods.add(member); //
                          addedMods.add(member);
                        }

                        return CheckboxListTile(
                          title: Text(user.name),
                          value: mods.contains(member),
                          onChanged: (val) {
                            if (val!) {
                              addMod(user.uid);
                            } else {
                              removeMod(user.uid);
                            }
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const CircularProgressIndicator(),
                    );
              }),
        )
      ]),
    );
  }
}
