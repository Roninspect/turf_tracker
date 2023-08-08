import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:turf_tracker/common/typedefs.dart';
import 'package:turf_tracker/models/user.dart';

import '../../../common/custom_snackbar.dart';
import '../../../common/failure.dart';
import '../../../common/storage_provider.dart';
import '../../auth/provider/user_data_notifer.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
      firestore: FirebaseFirestore.instance,
      storageRepository: ref.watch(storageRepositoryProvider),
      ref: ref);
});

class ProfileRepository {
  final FirebaseFirestore _firestore;
  final StorageRepository _storageRepository;
  final Ref _ref;
  ProfileRepository(
      {required FirebaseFirestore firestore,
      required StorageRepository storageRepository,
      required Ref ref})
      : _firestore = firestore,
        _storageRepository = storageRepository,
        _ref = ref;

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
