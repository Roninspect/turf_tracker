import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';

import 'package:turf_tracker/models/icon.dart';

final updateSportsNotifierProvider =
    StateNotifierProvider<UpdateSportsNotifier, List<IconModel>>((ref) {
  return UpdateSportsNotifier(ref: ref);
});

class UpdateSportsNotifier extends StateNotifier<List<IconModel>> {
  final Ref ref;

  UpdateSportsNotifier({required this.ref})
      : super(ref.read(userDataNotifierProvider
            .select((value) => value.interestedSports)));

  void updateSports({required IconModel singleSport}) {
    state = [...state, singleSport];
  }

  void removeSports({required IconModel singleSport}) {
    state = state.where((t) => t != singleSport).toList();
  }
}
