import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/custom_snackbar.dart';
import '../../../common/snackbar.dart';
import '../../../models/user.dart';
import '../provider/user_data_notifer.dart';
import '../repository/auth_repository.dart';

final userProvider = StreamProvider<UserModel>((ref) {
  ref.watch(authRepositoryProvider);
  return ref
      .watch(authRepositoryProvider)
      .authStateChanges
      .where((user) => user != null)
      .exhaustMap((user) {
    return ref.watch(authRepositoryProvider).getUserDatafromFirestore();
  });
});

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  );
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);

  //* login function from auth repository
  void loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final res =
        await _authRepository.loginUser(email: email, password: password);

    res.fold((l) => showSnackbar(context: context, text: l.message), (r) {
      _ref.refresh(userProvider);
      _ref.refresh(userDataNotifierProvider);
    });
  }

  //* register function from auth repository
  registerUser({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String district,
    required BuildContext contexts,
  }) async {
    final res = await _authRepository.registerUser(
        district: district,
        phoneNumber: phoneNumber,
        name: name,
        email: email,
        password: password);

    res.fold((l) => showSnackbar(context: contexts, text: l.message), (r) {
      _ref.refresh(userProvider);
      _ref.refresh(userDataNotifierProvider);
    });
  }

  void singInWithGoogle(BuildContext context) async {
    _ref.read(authControllerProvider.notifier).state = true;

    final user = await _authRepository.signInWithGoogle();

    _ref.read(authControllerProvider.notifier).state = false;

    user.fold(
      (l) {
        return ErrorSnackbar().showsnackBar(context, l.toString());
      },
      (r) async {
        _ref.refresh(userProvider);
        _ref.refresh(userDataNotifierProvider);
      },
    );
  }

  // Future<UserModel> getData() async {
  //   return await _authRepository.getUserDatafromFirestore();
  // }

  void updateTheDistrict(
      {required UserModel withUpadatedUserModel,
      required BuildContext context}) async {
    state = true;
    final res = await _authRepository.updateTheDistrict(
        withUpadatedUserModel: withUpadatedUserModel);
    state = false;
    res.fold(
      (l) => showSnackbar(context: context, text: l.message),
      (r) => null,
    );
  }

  //** forgot passoword */

  void forgotPassword(
      {required String email, required BuildContext context}) async {
    final res = await _authRepository.forgotPassword(email: email);

    res.fold((l) => showSnackbar(context: context, text: l.message), (r) {
      context.pop();
      showSnackbar(context: context, text: "Please Check Your Email");
    });
  }
}
