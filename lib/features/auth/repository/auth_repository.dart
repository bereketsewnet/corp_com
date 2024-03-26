import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corp_com/common/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../common/repositories/common_firebase_storage_repository.dart';
import '../../../common/repositories/common_repository.dart';
import '../../../common/widgets/error.dart';
import '../../../common/widgets/loader.dart';
import '../../../models/user_model.dart';
import '../../../screens/mobile_layout_screen.dart';
import '../controller/auth_controller.dart';
import '../screens/otp_screen.dart';
import '../screens/user_information_screen.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      ref: ref),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ProviderRef ref;

  AuthRepository(
      {required this.auth, required this.firestore, required this.ref});

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.pushNamed(
            context,
            OTPScreen.routeName,
            arguments: verificationId,
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    String signUpMethod = 'phone_number';
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
        context,
        arguments: signUpMethod,
        UserInformationScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  signUpEmailAndPassword(
      String email, String password, BuildContext context) async {
    String signUpMethod = 'email';
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushNamedAndRemoveUntil(
        context,
        arguments: signUpMethod,
        UserInformationScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: 'Up--${e.toString()}');
    }
  }

  signInEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
     final user = await getCurrentUserData();
      // save all data local storage
      if(user != null)
        await saveUserDataToSharedPreferences(user);
      Navigator.pushNamed(
        context,
        MobileLayoutScreen.routeName,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: 'In--${e.toString()}');
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
    required String signUpMethod,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String indentifier;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      switch (signUpMethod) {
        case 'email':
          indentifier = auth.currentUser!.email!;
          break;
        case 'phone_number':
          indentifier = auth.currentUser!.phoneNumber!;
          break;
        case 'google':
          indentifier = auth.currentUser!.email!;
          break;
        default:
          indentifier = auth.currentUser!.email!;
          break;
      }

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebaseImage(
              'profilePic/$uid',
              profilePic,
            );
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        identifier: indentifier,
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap());
      // save all data local storage
      await saveUserDataToSharedPreferences(user);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    String signUpMethod = 'google';

    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    UserCredential userCredential = await auth.signInWithCredential(credential);
    Navigator.pushNamedAndRemoveUntil(
      context,
      arguments: signUpMethod,
      UserInformationScreen.routeName,
      (route) => false,
    );
    print(userCredential.user?.displayName);
    return userCredential;
  }

  void signOut() async {
    await GoogleSignIn().signOut();
    auth.signOut();
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }

  Future<UserModel?> getCurrentUserData() async {
   final userFromLocal = await getUserDataFromSharedPreferences();
   if(userFromLocal != null && userFromLocal.name != '') {
     return userFromLocal;
   }else{
     var userData =
     await firestore.collection('users').doc(auth.currentUser?.uid).get();
     UserModel? user;
     if (userData.data() != null) {
       user = UserModel.fromMap(userData.data()!);
     }
     return user;
   }

  }

  Stream<UserModel> UserData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  checkUserPlatform(BuildContext context)  {
    ref.read(currentUserProvider).when(
          data: (data) async {
            if(data == 'Android'){
           final user = await signInWithGoogle(context);
            }else{
              showSnackBar(context: context, content: 'Other');
            }
          },
          error: (err, trace) {
            const ErrorScreen();
          },
          loading: () => const Loader(),
        );

    // IOS , Android , Web
  }
}
