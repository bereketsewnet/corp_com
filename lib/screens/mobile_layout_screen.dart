import 'dart:io';

import 'package:corp_com/common/utils/utils.dart';
import 'package:corp_com/features/auth/controller/auth_controller.dart';
import 'package:corp_com/features/auth/screens/choose_login_method.dart';
import 'package:corp_com/features/group/screens/group_list_screen.dart';
import 'package:corp_com/features/status/screens/confirm_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/screens/display_all_users.dart';
import '../common/utils/colors.dart';
import '../features/chat/controller/chat_controller.dart';
import '../features/chat/widgets/chat_users_list.dart';
import '../features/group/screens/create_group_screen.dart';
import '../features/status/screens/status_contacts_screen.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  static const String routeName = '/mobile-layout';

  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  int totalUnreadCount = 0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    getallUnread();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.grey,
            ),
          ),
          title: const Text(
            'CorpCom',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text(
                    'Create Group',
                  ),
                  onTap: () => Future(
                    () => Navigator.pushNamed(
                        context, CreateGroupScreen.routeName),
                  ),
                ),
                PopupMenuItem(
                  child: const Text(
                    'Logout',
                  ),
                  onTap: () => Future(
                    () async {
                      ref.read(authControllerProvider).logOut();
                      await clearUserDataFromSharedPreferences();
                      Navigator.pushNamed(context, ChooseLoginMethod.routeName);
                    },
                  ),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Personal'),
                    const SizedBox(width: 5),
                    Consumer(
                      builder: (context, watch, child) {
                        final counter = ref.watch(counterProvider).counter;
                        return Visibility(
                          visible: counter > 0,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: tabColor,
                            child: Text(
                              counter.toString(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Tab(
                text: 'GROUP',
              ),
              const Tab(
                text: 'STATUS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabBarController,
          children: const [
            ChattingUsersList(),
            GroupListScreen(),
            StatusContactsScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabBarController.index == 0) {
              Navigator.pushNamed(context, DisplayAllUsers.routeName);
            } else if (tabBarController.index == 1) {
              Navigator.pushNamed(context, CreateGroupScreen.routeName);
            } else {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                Navigator.pushNamed(
                  context,
                  ConfirmStatusScreen.routeName,
                  arguments: pickedImage,
                );
              }
            }
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  getallUnread() async {
    int temp = await retrieveTotalUnreadMessage();
    setState(() {
      totalUnreadCount = temp;
    });
  }
}
