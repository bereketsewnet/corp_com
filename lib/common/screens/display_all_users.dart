import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/chat/controller/chat_controller.dart';
import '../../features/chat/screens/mobile_chat_screen.dart';
import '../../models/user_model.dart';
import '../utils/colors.dart';
import '../widgets/loader.dart';

class DisplayAllUsers extends ConsumerWidget {
  static const String routeName = '/display-all-user';
  const DisplayAllUsers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
      
              StreamBuilder<List<UserModel>>(
                stream: ref.watch(chatControllerProvider).getAllUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }
      
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var user = snapshot.data![index];
      
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                MobileChatScreen.routeName,
                                arguments: {
                                  'name': user.name,
                                  'uid': user.uid,
                                  'isGroupChat': false,
                                  'profilePic': user.profilePic,
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    user.profilePic,
                                  ),
                                  radius: 30,
                                ),
                                title: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 18,
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
      ),
    );
  }
}