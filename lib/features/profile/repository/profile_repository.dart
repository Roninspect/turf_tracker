import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:turf_tracker/common/typedefs.dart';
import 'package:turf_tracker/models/user.dart';
import '../../../common/failure.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    firestore: FirebaseFirestore.instance,
  );
});

class ProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  FutureVoid editProfile(UserModel userModel) async {
    try {
      return right(await _firestore
          .collection("users")
          .doc(userModel.uid)
          .update(userModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
