import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/teams/controller/team_controller.dart';
import 'package:turf_tracker/models/team.dart';

final searchedTeamNotifierProvider =
    NotifierProvider<SearchedTeamNotifier, List<Team>>(
        SearchedTeamNotifier.new);

class SearchedTeamNotifier extends Notifier<List<Team>> {
  @override
  build() {
    return [];
  }

  void fetchTeamBySearch(
      {required BuildContext context, required String searchQuery}) async {
    state = await ref
        .watch(teamControllerProvider.notifier)
        .searchTeam(searchQuery);
  }
}
