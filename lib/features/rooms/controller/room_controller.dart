import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';
import 'package:turf_tracker/features/rooms/repository/rooms_repository.dart';
import 'package:uuid/uuid.dart';
import '../../../common/custom_snackbar.dart';
import '../../../models/room.dart';

final roomControllerProvider =
    StateNotifierProvider<RoomController, bool>((ref) {
  return RoomController(
      roomRepository: ref.watch(roomRepositoryProvider), ref: ref);
});

final getAllActiveRoomsByDistrictProvider =
    StreamProvider.family<List<Room>, String>((ref, selectedDistrict) {
  return ref
      .watch(roomControllerProvider.notifier)
      .getAllActiveRoomsByDistrict(selectedDistrict: selectedDistrict);
});
final getRoomByIdProvider =
    StreamProvider.family.autoDispose<Room, String>((ref, roomId) {
  return ref.watch(roomControllerProvider.notifier).getRoomById(roomId: roomId);
});
final getAllInactiveRoomsByDistrictProvider =
    StreamProvider.family<List<Room>, String>((ref, selectedDistrict) {
  return ref
      .watch(roomControllerProvider.notifier)
      .getAllInactiveRoomsByDistrict(selectedDistrict: selectedDistrict);
});
final getMyRoomsProvider = StreamProvider<List<Room>>((ref) {
  return ref.watch(roomControllerProvider.notifier).getMyRooms();
});

class RoomController extends StateNotifier<bool> {
  final RoomRepository _roomRepository;
  final Ref _ref;
  RoomController({required RoomRepository roomRepository, required Ref ref})
      : _roomRepository = roomRepository,
        _ref = ref,
        super(false);

  void shareMatchInRoom({
    required String bookerNumber,
    required String turfId,
    required String turfName,
    required String turfAddress,
    required String bookingId,
    required String dimension,
    required String bookedBy,
    required Timestamp startTime,
    required Timestamp endTime,
    required num totalPrice,
    required String district,
    required BuildContext context,
  }) async {
    state = true;
    final String roomId = const Uuid().v4();
    final newRoom = Room(
        roomId: roomId,
        uid: FirebaseAuth.instance.currentUser!.uid,
        joinedBy: '',
        joinedByName: '',
        joinedByNumber: '',
        isActive: true,
        isExpired: false,
        isLocked: false,
        bookerNumber: bookerNumber,
        bookingId: bookingId,
        turfId: turfId,
        turfName: turfName,
        turfAddress: turfAddress,
        dimension: dimension,
        bookedBy: bookedBy,
        startTime: startTime,
        endTime: endTime,
        district: district,
        totalPrice: totalPrice);
    final res = await _roomRepository.shareMatchInRoom(room: newRoom);
    state = false;
    res.fold(
      (l) => showSnackbar(context: context, text: l.message),
      (r) => showSnackbar(context: context, text: "Successfully Added"),
    );
  }

  void cancelRoom({
    required String roomId,
    required BuildContext context,
  }) async {
    final res = await _roomRepository.cancelRoom(roomId: roomId);

    res.fold(
      (l) => showSnackbar(context: context, text: l.message),
      (r) => showSnackbar(
          context: context, text: "Deleted Added", color: Colors.red),
    );
  }

  void joinRoom({
    required String roomId,
    required BuildContext context,
  }) async {
    state = true;
    final user = _ref.read(userDataNotifierProvider);
    final res = await _roomRepository.joinRoom(
        roomId: roomId,
        uid: user.uid,
        phoneNumber: user.phoneNumber,
        joinedByName: user.name);
    state = false;
    res.fold(
        (l) => showSnackbar(
              context: context,
              text: l.message,
            ), (r) {
      showSnackbar(context: context, text: "Joined the room");
    });
  }

  Stream<List<Room>> getAllActiveRoomsByDistrict(
      {required String selectedDistrict}) {
    return _roomRepository.getActiveAllRoomsByDistrict(
        district: selectedDistrict);
  }

  Stream<List<Room>> getAllInactiveRoomsByDistrict(
      {required String selectedDistrict}) {
    final user = _ref.read(userDataNotifierProvider);
    return _roomRepository.getAllInactiveRoomsByDistrict(
        uid: user.uid, district: selectedDistrict);
  }

  Stream<List<Room>> getMyRooms() {
    final user = _ref.read(userDataNotifierProvider);
    return _roomRepository.getMyRooms(uid: user.uid);
  }

  Stream<Room> getRoomById({required String roomId}) {
    return _roomRepository.getRoomById(roomId: roomId);
  }
}
