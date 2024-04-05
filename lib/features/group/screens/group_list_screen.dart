import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/utils/colors.dart';
import '../../../common/widgets/loader.dart';
import '../../../models/group.dart';
import '../../chat/controller/chat_controller.dart';
import '../../chat/screens/mobile_chat_screen.dart';

class GroupListScreen extends ConsumerStatefulWidget {
  const GroupListScreen({super.key});

  @override
  ConsumerState createState() => _GroupListScreenState();
}

class _GroupListScreenState extends ConsumerState<GroupListScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Group>>(
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
    );
  }
}
