import 'dart:convert';

import 'package:corp_com/models/chat_contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodeTest extends ConsumerStatefulWidget {
  const CodeTest({super.key});

  @override
  ConsumerState createState() => _CodeTestState();
}

class _CodeTestState extends ConsumerState<CodeTest> {
  late FutureProvider<List<ChatContact>> userListProvider;

  @override
  void initState() {
    userListProvider = FutureProvider<List<ChatContact>>((ref) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? json = prefs.getString('startChattingUsersList');

      if (json != null) {
        List<dynamic> jsonList = jsonDecode(json);
        List<ChatContact> userList =
            jsonList.map((item) => ChatContact.fromMap(item)).toList();
        return userList;
      }

      return [];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userListAsyncValue = ref.watch(userListProvider);
    return Scaffold(
      appBar: AppBar(),
      body: userListAsyncValue.when(
        data: (userList) {
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (BuildContext context, int index) {
              ChatContact user = userList[index];
              // Build the UI for each user
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(user.lastMessage),
                trailing: Text(user.timeSent.toString()),
              );
            },
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text(
          'Error: $error',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
