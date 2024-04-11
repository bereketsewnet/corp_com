import 'package:corp_com/features/auth/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';

final localUserInfoRepositoryProvider = Provider(
  (ref) async => LocalUserInfoRepository(
    prefs: await SharedPreferences.getInstance(),
    ref: ref,
  ),
);

class LocalUserInfoRepository {
  SharedPreferences prefs;
  ProviderRef ref;

  LocalUserInfoRepository({
    required this.prefs,
    required this.ref,
  });

  // Save user data to SharedPreferences
  saveUserDataToSharedPreferences(UserModel user) async {
    prefs.setString('name', user.name);
    prefs.setString('identifier', user.identifier);
    prefs.setString('uid', user.uid);
    prefs.setString('profilePic', user.profilePic);
    prefs.setBool('isOnline', user.isOnline);
    prefs.setStringList('groupId', user.groupId);
    // Save other user data as needed
  }
}
