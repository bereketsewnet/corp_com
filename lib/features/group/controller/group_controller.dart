import 'dart:io';

import 'package:corp_com/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../chat/controller/chat_controller.dart';
import '../repository/group_repository.dart';

final groupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(groupRepositoryProvider);
  return GroupController(
    groupRepository: groupRepository,
    ref: ref,
  );
});

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;

  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File profilePic,
      List<UserModel> user) {
    return ref.read(groupRepositoryProvider).createGroup(context, name, profilePic, user);
  }

   getGroupUserInUse(BuildContext context) {
    groupRepository.getGroupUserInUse(context);
  }

  void setGroupChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) {
    groupRepository.setGroupChatMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }
}

final groupCounterProvider = ChangeNotifierProvider((ref) => groupCounter());

class groupCounter extends ChangeNotifier {
  int _groupCounter = 0;

  int get group_counter => _groupCounter;

  Future<void> loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _groupCounter = prefs.getInt('GroupTotalUnread') ?? 0;
    notifyListeners();
  }

  Future<void> setCounter(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _groupCounter = value;
    await prefs.setInt('GroupTotalUnread', value);
    notifyListeners();
  }

  Future<void> decreaseCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _groupCounter--;
    await prefs.setInt('GroupTotalUnread', _groupCounter);
    notifyListeners();
  }
}
