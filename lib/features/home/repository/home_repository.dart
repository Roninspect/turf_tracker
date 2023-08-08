import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/models/favorites.dart';
import 'package:turf_tracker/models/turf.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(firestore: FirebaseFirestore.instance);
});

class HomeRepository {
  final FirebaseFirestore _firestore;

  HomeRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  //** getting favorite by user id */
  Stream<List<Favorite>> getFavoriteByUid({required String uid}) {
    return _firestore
        .collection("favorites")
        .where("uid", isEqualTo: uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Favorite.fromMap(e.data())).toList());
  }

  //** getting all favourite turf of user */

  Stream<List<Turf>> getFavorite({required String turfId}) {
    return _firestore
        .collection("turfs")
        .where("turfId", isEqualTo: turfId)
        .snapshots()
        .map((event) => event.docs.map((e) => Turf.fromMap(e.data())).toList());
  }
}
