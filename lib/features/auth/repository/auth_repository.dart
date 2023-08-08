// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../common/constants.dart';
import '../../../common/failure.dart';
import '../../../common/typedefs.dart';
import '../../../models/user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
      auth: FirebaseAuth.instance,
      googleSignIn: GoogleSignIn(),
      firestore: FirebaseFirestore.instance,
      ref: ref);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final hasUserSelectedDistrictProvider = StreamProvider<UserModel>((ref) {
  return ref
      .watch(authRepositoryProvider)
      .hasUserSelectedDistrict(uid: FirebaseAuth.instance.currentUser!.uid);
});

class AuthRepository {
  FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  final Ref ref;

  AuthRepository({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
    required this.ref,
  })  : _auth = auth,
        _googleSignIn = googleSignIn,
        _firestore = firestore;

  CollectionReference get _user => _firestore.collection('users');

//* listening to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  //* login user function
  FutureVoid loginUser({
    required String email,
    required String password,
  }) async {
    try {
      return right(
        await _auth.signInWithEmailAndPassword(
            email: email, password: password),
      );
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    }
  }

//* login with google
  FutureVoid signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final credential = GoogleAuthProvider.credential(
        accessToken: (await googleUser!.authentication).accessToken,
        idToken: (await googleUser.authentication).idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      UserModel userDetails;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userDetails = UserModel(
            name: userCredential.user!.displayName ?? 'no name',
            uid: userCredential.user!.uid,
            email: userCredential.user!.email ?? "no  email",
            address: "",
            district: "",
            profilePic:
                userCredential.user!.photoURL ?? Constants.avatarDefault,
            phoneNumber: userCredential.user!.phoneNumber ?? "",
            rewardsPoint: 0,
            bookingsNo: 0,
            interestedSports: [],
            hasGivenReview: false);
        return right(
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(userDetails.toMap()),
        );
      }

      // ignore: avoid_print
      return right(print("not new"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //* registering a user
  FutureVoid registerUser(
      {required String name,
      required String phoneNumber,
      required String password,
      required String district,
      required String email}) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String userId = userCred.user!.uid;

      final userModel = UserModel(
          name: name,
          uid: userId,
          email: email,
          address: "",
          district: district,
          phoneNumber: phoneNumber,
          profilePic: Constants.avatarDefault,
          rewardsPoint: 0,
          bookingsNo: 0,
          interestedSports: [],
          hasGivenReview: false);

      return right(
        await _firestore.collection('users').doc(userId).set(userModel.toMap()),
      );
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserDatafromFirestore() {
    return _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .snapshots()
        .map(
            (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<UserModel> hasUserSelectedDistrict({required String uid}) {
    return _firestore
        .collection("users")
        .where("uid", isEqualTo: uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => UserModel.fromMap(e.data())).first);
  }

  FutureVoid updateTheDistrict(
      {required UserModel withUpadatedUserModel}) async {
    try {
      return right(await _firestore
          .collection('users')
          .doc(withUpadatedUserModel.uid)
          .set(withUpadatedUserModel.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid forgotPassword({required String email}) async {
    try {
      return right(await _auth.sendPasswordResetEmail(email: email));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
