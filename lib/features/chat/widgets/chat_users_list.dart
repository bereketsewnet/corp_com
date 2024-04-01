import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corp_com/features/chat/controller/chat_controller.dart';
import 'package:corp_com/features/chat/repositories/chat_repository.dart';
import 'package:corp_com/models/chat_contact.dart';
import 'package:corp_com/models/group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/utils/colors.dart';
import '../../../common/widgets/loader.dart';
import '../../../models/message.dart';
import '../screens/mobile_chat_screen.dart';

class ChattingUsersList extends ConsumerStatefulWidget {
  const ChattingUsersList({super.key});

  @override
  ConsumerState createState() => _ChattingUsersListState();
}

class _ChattingUsersListState extends ConsumerState<ChattingUsersList> {
  int unreadMessagesCount = 0;

  @override
  void initState() {
    super.initState();
     getReceiverIds();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<ChatContact>>(
              stream: ref.read(chatControllerProvider).chatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var chatContactData = snapshot.data![index];
                    // String un = snapshot.data![index]['unread'];

                    return StreamBuilder<List<Message>>(
                      stream: ref
                          .read(chatControllerProvider)
                          .chatStream(chatContactData.contactId),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return Container();
                        }
                        getReceiverIds();
                        // for (int i = 0; i < snap.data!.length; i++) {
                        //   final messageData = snap.data![i];
                        //   if (!messageData.isSeen &&
                        //       messageData.receiverId ==
                        //           FirebaseAuth.instance.currentUser!.uid) {
                        //     setUnreadMessageIncrease(
                        //       context,
                        //       chatContactData.contactId,
                        //     );
                        //     print(1);
                        //   }
                        // }

                        // snap.data!.forEach((messageData) {
                        //   if (!messageData.isSeen &&
                        //       messageData.receiverId ==
                        //           FirebaseAuth.instance.currentUser!.uid) {
                        //     // setUnreadMessageIncrease(
                        //     //   context,
                        //     //   chatContactData.contactId,
                        //     // );
                        //     ChatRepository(
                        //       firestore: FirebaseFirestore.instance,
                        //       auth: FirebaseAuth.instance,
                        //     ).setUnreadMessageIncrease(
                        //       context,
                        //       chatContactData.contactId,
                        //     );
                        //     print(1);
                        //   }
                        // });

                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  MobileChatScreen.routeName,
                                  arguments: {
                                    'name': chatContactData.name,
                                    'uid': chatContactData.contactId,
                                    'isGroupChat': false,
                                    'profilePic': chatContactData.profilePic,
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ListTile(
                                  title: Text(
                                    chatContactData.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.done_all_rounded,
                                          color: Colors.lightBlueAccent,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          chatContactData.lastMessage,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      chatContactData.profilePic,
                                    ),
                                    radius: 30,
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat.Hm()
                                            .format(chatContactData.timeSent),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                      chatContactData.unread != 0 && chatContactData.unread != null
                                          ? CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.red,
                                              child: Text(
                                                chatContactData.unread.toString(),
                                              ),
                                            )
                                          : const CircleAvatar(radius: 0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Divider(color: dividerColor, indent: 85),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            StreamBuilder<List<Group>>(
              stream: ref.watch(chatControllerProvider).chatGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var groupData = snapshot.data![index];

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              MobileChatScreen.routeName,
                              arguments: {
                                'name': groupData.name,
                                'uid': groupData.groupId,
                                'isGroupChat': true,
                                'profilePic': groupData.groupPic,
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                groupData.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.done_rounded,
                                      color: Colors.lightBlueAccent,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      groupData.lastMessage,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  groupData.groupPic,
                                ),
                                radius: 30,
                              ),
                              trailing: Text(
                                DateFormat.Hm().format(groupData.timeSent),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(color: dividerColor, indent: 85),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  setUnreadMessageIncrease(BuildContext context, String receiverUserId) {
    ref
        .read(chatControllerProvider)
        .setUnreadMessageIncrease(context, receiverUserId);
  }
  getReceiverIds() async{
   await ref.read(chatControllerProvider).getReceiverIds(context);

  }
}
