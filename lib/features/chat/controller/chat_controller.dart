import 'package:corp_com/features/auth/controller/auth_controller.dart';
import 'package:corp_com/features/chat/repositories/chat_repository.dart';
import 'package:corp_com/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/chat_contact.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts(){
    return chatRepository.getChatContacts();
  }
  Stream<List<Message>> chatStream(String receiverUserId){
    return chatRepository.getChatStream(receiverUserId);
  }

  void sendTextMessage(
      BuildContext context, String text, String receiverUserId) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUser: value!,
          ),
        );
  }
}
