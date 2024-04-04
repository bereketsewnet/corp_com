import 'package:corp_com/common/providers/message_reply_provider.dart';
import 'package:corp_com/common/widgets/loader.dart';
import 'package:corp_com/features/chat/controller/chat_controller.dart';
import 'package:corp_com/features/chat/widgets/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../common/utils/utils.dart';
import '../features/chat/widgets/my_message_card.dart';
import '../models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList(
      {Key? key, required this.receiverUserId, required this.isGroupChat})
      : super(key: key);

  final String receiverUserId;
  final bool isGroupChat;

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final messageScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    decreaseUnreadMessage(widget.receiverUserId, 0);
  }

  @override
  void dispose() {
    super.dispose();
    messageScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: widget.isGroupChat
            ? ref
                .read(chatControllerProvider)
                .groupChatStream(widget.receiverUserId)
            : ref
                .read(chatControllerProvider)
                .chatStream(widget.receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageScrollController
                .jumpTo(messageScrollController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: messageScrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);

              if (!messageData.isSeen &&
                  messageData.receiverId ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                      context,
                      widget.receiverUserId,
                      messageData.messageId,
                    );
              }
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.type,
                  repliedMessageType: messageData.repliedMessageType,
                  repliedText: messageData.repliedMessage,
                  username: messageData.repliedTo,
                  isSeen: messageData.isSeen,
                  onLeftSwipe: () => onMessageSwipe(
                    messageData.text,
                    true,
                    messageData.type,
                  ),
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                onRightSwipe: () => onMessageSwipe(
                  messageData.text,
                  false,
                  messageData.type,
                ),
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
              );
            },
          );
        });
  }

  void onMessageSwipe(String message, bool isMe, messageEnum) {
    ref.read(messageReplyProvider.state).update(
          (state) => MessageReply(message, isMe, messageEnum),
        );
  }

  decreaseUnreadMessage(String receiverUserId, int unreadCount) async {
    final user = await getUserDataFromSharedPreferences();
    String uid;
    if (user != null) {
      uid = user.uid;
    } else {
      uid = FirebaseAuth.instance.currentUser!.uid;
    }
    ref
        .read(chatControllerProvider)
        .setUnreadMessageIncrease(context, receiverUserId, uid, unreadCount);
  }
}
