import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/chat_contact.dart';
import '../../../models/user_model.dart';

final localUserDataRepoProvider = Provider.autoDispose(
  (ref) => LocalUserDataRepository(
    ref: ref,
  ),
);

class LocalUserDataRepository {
  final ProviderRef ref;

  LocalUserDataRepository({
    required this.ref,
  });
 // Saving Users that start chat with me in shared Preference
  saveStartChattingUserList(ChatContact chatContact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ChatContact> chatUserList = [];
    chatUserList.clear();

    // Retrieve the existing list of users from SharedPreferences
    String? json = prefs.getString('startChattingUsersList');
    if (json != null) {
      List<dynamic> jsonList = jsonDecode(json);
      chatUserList = jsonList.map((item) => ChatContact.fromMap(item)).toList();
    }

    // Check if the user already exists in the list
    bool userExists = chatUserList.any((user) => user.contactId == chatContact.contactId);

    if (!userExists) {
      // Add the new user to the list
      chatUserList.add(chatContact);

      // Convert the list of users to JSON
      String updatedJson =
      jsonEncode(chatUserList.map((user) => user.toMap()).toList());

      // Save the updated JSON string to SharedPreferences
      await prefs.setString('startChattingUsersList', updatedJson);
    }
  }

// Retrieve the User that start chat with me
  Future<List<ChatContact>> getChattingUserList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString('startChattingUsersList');

    if (json != null) {
      List<dynamic> jsonList = jsonDecode(json);
      List<ChatContact> userList = jsonList.map((item) => ChatContact.fromMap(item)).toList();
      return userList;
    }

    return [];
  }

}
