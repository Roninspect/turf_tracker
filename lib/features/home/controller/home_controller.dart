import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/home/repository/home_repository.dart';

import '../../../models/favorites.dart';
import '../../../models/turf.dart';

final homeControllerProvider = Provider<HomeController>((ref) {
  return HomeController(homeRepository: ref.watch(homeRepositoryProvider));
});

final getFavoriteByUidProvider = StreamProvider<List<Favorite>>((ref) {
  return ref.watch(homeControllerProvider).getFavoriteByUid();
});

final getFavoriteProvider =
    StreamProvider.family<List<Turf>, String>((ref, turfId) {
  return ref.watch(homeControllerProvider).getFavorite(turfId: turfId);
});

class HomeController {
  final HomeRepository _homeRepository;

  HomeController({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;

  //** getting favorite by user id */
  Stream<List<Favorite>> getFavoriteByUid() {
    return _homeRepository.getFavoriteByUid(
        uid: FirebaseAuth.instance.currentUser!.uid);
  }

  //** getting all favourite turf of user */
  Stream<List<Turf>> getFavorite({required String turfId}) {
    return _homeRepository.getFavorite(turfId: turfId);
  }
}
