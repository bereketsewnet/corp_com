import 'dart:convert';

import 'package:corp_com/common/permisson/permisson_android.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/chat_contact.dart';
import '../../models/user_model.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  await checkPermissionsAll();
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(
        pickedImage.path,
      );
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return video;
}

// Save user data to SharedPreferences
Future<void> saveUserDataToSharedPreferences(UserModel user) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('name', user.name);
  prefs.setString('identifier', user.identifier);
  prefs.setString('uid', user.uid);
  prefs.setString('profilePic', user.profilePic);
  prefs.setBool('isOnline', user.isOnline);
  prefs.setStringList('groupId', user.groupId);
  // Save other user data as needed
}

// Retrieve user data from SharedPreferences
Future<UserModel?> getUserDataFromSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('name') ?? '';
  final identifier = prefs.getString('identifier') ?? '';
  final uid = prefs.getString('uid') ?? '';
  final isOnline = prefs.getBool('isOnline') ?? false;
  final profilePic = prefs.getString('profilePic') ?? '';
  final groupId = prefs.getStringList('groupId') ?? [];
  // Retrieve other user data as needed

  return UserModel(
    name: name,
    identifier: identifier,
    uid: uid,
    profilePic: profilePic,
    isOnline: isOnline,
    groupId: groupId,
  );
}

// Save start chatting user data to SharedPreferences
Future<void> saveChatDataToSharedPreferences(List<ChatContact> chatList) async {
  final prefs = await SharedPreferences.getInstance();

  // Convert the list of ChatContact objects to a list of Map<String, String>
  List<Map<String, String>> chatDataList = chatList.map((chat) {
    return {
      'name': chat.name,
      'profilePic': chat.profilePic,
      'contactId': chat.contactId,
      'timeSent': chat.timeSent.toString(),
      'lastMessage': chat.lastMessage,
      // Add other properties of ChatContact as needed
    };
  }).toList();

  // Convert the list of Map<String, String> to a list of String
  List<String> serializedChatDataList = chatDataList.map((chatData) {
    return jsonEncode(chatData);
  }).toList();

  // Store the serialized list in SharedPreferences
  await prefs.setStringList('chatList', serializedChatDataList);
}

Future<List<ChatContact>?> getChatDataFromSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  final chatDataList = prefs.getStringList('chatList');


    List<ChatContact> chatList = chatDataList!.map((serializedChatData) {
      Map<String, String> chatData = jsonDecode(serializedChatData);
      return ChatContact(
        name: chatData['name'] ?? '',
        profilePic: chatData['profilePic'] ?? '',
        contactId: chatData['contactId'] ?? '',
        timeSent: DateTime.parse(chatData['timeSent'] ?? ''),
        lastMessage: chatData['lastMessage'] ?? '',
        // Initialize other properties of ChatContact as needed
      );
    }).toList();

    return chatList;
// to get saved file ...
// List<ChatContact>? loadedChatList = await getChatDataFromSharedPreferences();
}

// Clear user data from SharedPreferences
Future<void> clearUserDataFromSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('name');
  prefs.remove('identifier');
  prefs.remove('uid');
  prefs.remove('isOnline');
  prefs.remove('profilePic');
  prefs.remove('groupId');
  // Remove other user data keys as needed
}

// Future<GiphyGif?> pickGIF(BuildContext context) async {
//   GiphyGif? gif;
//   try {
//     gif = await Giphy.getGif(
//       context: context,
//       apiKey: 'opW8aChglMOFQQ9SOApqhmn4KDQBJb0P',
//     );
//   } catch (e) {
//     showSnackBar(context: context, content: e.toString());
//   }
//   return gif;
// }
