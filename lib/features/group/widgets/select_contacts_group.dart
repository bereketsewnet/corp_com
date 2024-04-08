import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/colors.dart';
import '../../../common/widgets/error.dart';
import '../../../common/widgets/loader.dart';
import '../../../models/user_model.dart';
import '../../chat/controller/chat_controller.dart';
import '../../chat/screens/mobile_chat_screen.dart';
import '../../select_contacts/controller/select_contact_controller.dart';

final selectedGroupContacts = StateProvider<List<UserModel>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, UserModel user) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref.read(selectedGroupContacts.state).update((state) => [...state, user]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
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

            return InkWell(
              onTap: () => selectContact(index, user),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  leading: selectedContactsIndex.contains(index)
                      ? IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.done),
                        )
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// return ref.watch(getContactsProvider).when(
// data: (contactList) => Expanded(
// child: ListView.builder(
// itemCount: contactList.length,
// itemBuilder: (context, index) {
// final contact = contactList[index];
// return InkWell(
// onTap: () => selectContact(index, contact),
// child: Padding(
// padding: const EdgeInsets.only(bottom: 8),
// child: ListTile(
// title: Text(
// contact.displayName,
// style: const TextStyle(
// fontSize: 18,
// ),
// ),
// leading: selectedContactsIndex.contains(index)
// ? IconButton(
// onPressed: () {},
// icon: const Icon(Icons.done),
// )
//     : null,
// ),
// ),
// );
// }),
// ),
// error: (err, trace) => ErrorScreen(
// error: err.toString(),
// ),
// loading: () => const Loader(),
// );
