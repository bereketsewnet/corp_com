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
                                  chatContactData.unread! > 0 &&
                                          chatContactData.unread != null
                                      ? const Icon(
                                          Icons.done_rounded,
                                          color: Colors.lightBlueAccent,
                                          size: 20,
                                        )
                                      : const Icon(
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
                                chatContactData.unread! > 0 &&
                                        chatContactData.unread != null
                                    ? CircleAvatar(
                                        radius: 10,
                                        backgroundColor: tabColor,
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
          ),

        ],
      ),
    );
  }

  getReceiverIds() async {
    await ref.read(chatControllerProvider).getReceiverIds(context);
  }
}
