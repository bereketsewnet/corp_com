import 'dart:io';
import 'package:corp_com/common/repositories/common_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});
final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});



class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void logOut() {
    authRepository.signOut();
  }

  Future<UserCredential?> signInWithGoogle (BuildContext context) async{
   return authRepository.signInWithGoogle(context);
  }

  void signInWithEmailAndPassword(String email, String password, BuildContext context) {
    authRepository.signInEmailAndPassword(email, password, context);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic, String signUpMethod) {
    authRepository.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
      signUpMethod: signUpMethod,
    );
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }

//   Future<UserModel?> getUserData() async {
//     UserModel? user = await authRepository.getCurrentUserData();
//     return user;
//   }

  Future<String> getPlatform() async {
    String platform =
        await ref.read(commonRepositoryProvider).getCurrentPlatform();
    return platform;
  }

  signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    await ref.read(authRepositoryProvider).signUpEmailAndPassword(
          email,
          password,
          context,
        );
  }
}
