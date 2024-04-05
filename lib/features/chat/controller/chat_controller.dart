import 'dart:io';

import 'package:corp_com/common/enums/message_enum.dart';
import 'package:corp_com/common/providers/message_reply_provider.dart';
import 'package:corp_com/features/auth/controller/auth_controller.dart';
import 'package:corp_com/features/chat/repositories/chat_repository.dart';
import 'package:corp_com/models/group.dart';
import 'package:corp_com/models/message.dart';
import 'package:corp_com/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/chat_contact.dart';

final chatControllerProvider = Provider.autoDispose((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

// final unreadCounterProvider = StateProvider<int>((ref) => 0);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<UserModel>> getAllUser() {
    return chatRepository.getAllUsers();
  }

  Stream<List<Group>> chatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Message>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  Stream<List<Message>> groupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  // Future<List<Map<String, dynamic>>> getAllUserUnreadMessage() {
  //   return chatRepository.getAllUserUnreadMessage();
  // }

  Future<List<String>?> getUnreadMessage(
      String receiverUserId, BuildContext context, String uid) {
    return chatRepository.getSpesficUnreadMessage(receiverUserId, context, uid);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUserId: receiverUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }

  void setUnreadMessageIncrease(
    BuildContext context,
    String receiverUserId,
    String uid,
    int unreadCount,
  ) {
    chatRepository.setUnreadMessageIncrease(
      context,
      receiverUserId,
      uid,
      unreadCount,
    );
  }

  getReceiverIds(BuildContext context) {
    chatRepository.getStartChattingUsersId(context);
  }
}

final counterProvider = ChangeNotifierProvider((ref) => Counter());

class Counter extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  Future<void> loadCounter() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('totalUnread') ?? 0;
    notifyListeners();
  }

  Future<void> setCounter(int value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = value;
    await prefs.setInt('totalUnread', value);
    notifyListeners();
  }
  Future<void> decreaseCounter() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter--;
    await prefs.setInt('totalUnread', _counter);
    notifyListeners();
  }
}
