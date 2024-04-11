
import 'package:corp_com/common/permisson/permisson_android.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

// save unread message for all starting chatting user total number
saveTotalUnreadMessage(int unreadCount) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('totalUnread', unreadCount);
}
// Retrieve total unreadMessage in to prefs
Future<int> retrieveTotalUnreadMessage() async {
  final prefs = await SharedPreferences.getInstance();
  final totalUnreadMessage = prefs.getInt('totalUnread') ?? 0;
  return totalUnreadMessage;
}

