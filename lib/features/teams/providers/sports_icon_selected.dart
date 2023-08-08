import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/models/icon.dart';

final iconsSelectedNotifierProvider =
    NotifierProvider<IconsSelectedNotifier, List<IconModel>>(
        IconsSelectedNotifier.new);

class IconsSelectedNotifier extends Notifier<List<IconModel>> {
  @override
  List<IconModel> build() {
    return [];
  }

  void addSports({required IconModel iconModel}) {
    state = [...state, iconModel];
  }

  void removeSelectedSport({required IconModel iconModel}) {
    state = state.where((t) => t != iconModel).toList();
  }

  void addExstingSports({required List<IconModel> existingSports}) {
    state = [...state, ...existingSports];
  }
}
