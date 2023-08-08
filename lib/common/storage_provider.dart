import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:turf_tracker/common/typedefs.dart';

import 'failure.dart';

final storageRepositoryProvider =
    Provider((ref) => StorageRepository(storage: FirebaseStorage.instance));

class StorageRepository {
  final FirebaseStorage _storage;
  StorageRepository({required FirebaseStorage storage}) : _storage = storage;

  FutureEither<String> storeFile(
      {required String path, required String id, required File file}) async {
    try {
      Reference ref = _storage.ref().child(path).child(id);

      UploadTask uploadFile = ref.putFile(file);

      final snapshot = await uploadFile;

      String getDownloadUrl = await snapshot.ref.getDownloadURL();

      return right(getDownloadUrl);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
