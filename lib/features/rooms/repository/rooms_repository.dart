import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:turf_tracker/common/failure.dart';
import 'package:turf_tracker/common/typedefs.dart';
import 'package:turf_tracker/models/room.dart';

final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  return RoomRepository(firestore: FirebaseFirestore.instance);
});

class RoomRepository {
  final FirebaseFirestore _firestore;
  RoomRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid shareMatchInRoom({required Room room}) async {
    try {
      return right(
        await _firestore.collection("rooms").doc(room.roomId).set(room.toMap()),
      );
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    }
  }

  FutureVoid cancelRoom({required String roomId}) async {
    try {
      return right(
        await _firestore.collection("rooms").doc(roomId).delete(),
      );
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    }
  }

  FutureVoid joinRoom(
      {required String roomId,
      required String uid,
      required String joinedByName,
      required String phoneNumber}) async {
    try {
      return right(
        await _firestore.collection("rooms").doc(roomId).update({
          'isActive': false,
          "joinedBy": uid,
          'joinedByName': joinedByName,
          'joinedByNumber': phoneNumber,
        }),
      );
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    }
  }

  Stream<List<Room>> getActiveAllRoomsByDistrict({
    required String district,
  }) {
    return _firestore
        .collection("rooms")
        .where("district", isEqualTo: district)
        .where("isActive", isEqualTo: true)
        .where("isExpired", isEqualTo: false)
        .snapshots()
        .map(
          (event) => event.docs.map((e) => Room.fromMap(e.data())).toList(),
        );
  }

  Stream<List<Room>> getAllInactiveRoomsByDistrict(
      {required String district, required String uid}) {
    return _firestore
        .collection("rooms")
        .where("district", isEqualTo: district)
        .where(
          Filter.or(
            Filter('uid', isEqualTo: uid),
            Filter('joinedBy', isEqualTo: uid),
          ),
        )
        .where("isActive", isEqualTo: false)
        .where("isExpired", isEqualTo: false)
        .snapshots()
        .map(
          (event) => event.docs.map((e) => Room.fromMap(e.data())).toList(),
        );
  }

  Stream<List<Room>> getMyRooms({required String uid}) {
    return _firestore
        .collection("rooms")
        .where("uid", isEqualTo: uid)
        .where("isExpired", isEqualTo: false)
        .snapshots()
        .map(
          (event) => event.docs.map((e) => Room.fromMap(e.data())).toList(),
        );
  }

  Stream<Room> getRoomById({required String roomId}) {
    return _firestore
        .collection("rooms")
        .doc(roomId)
        .snapshots()
        .map((event) => Room.fromMap(event.data() as Map<String, dynamic>));
  }

  Query<Room> getExpiredRoomsByUid({required String uid}) {
    return _firestore
        .collection('rooms')
        .where("isExpired", isEqualTo: true)
        .where("uid", isEqualTo: uid)
        .withConverter<Room>(
          fromFirestore: (snapshot, _) =>
              Room.fromMap(snapshot.data() as Map<String, dynamic>),
          toFirestore: (user, _) => user.toMap(),
        );
  }
}
