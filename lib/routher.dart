import 'dart:io';

import 'package:corp_com/common/screens/display_all_users.dart';
import 'package:corp_com/common/widgets/error.dart';
import 'package:corp_com/features/auth/screens/choose_login_method.dart';
import 'package:corp_com/features/auth/screens/login_with_phone_screen.dart';
import 'package:corp_com/features/auth/screens/otp_screen.dart';
import 'package:corp_com/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter/material.dart';

import 'features/auth/screens/user_information_screen.dart';
import 'features/group/screens/create_group_screen.dart';
import 'features/select_contacts/screens/select_contacts_screen.dart';
import 'features/status/screens/confirm_status_screen.dart';
import 'features/status/screens/status_screen.dart';
import 'models/status_model.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginWithPhoneScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginWithPhoneScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );

    case UserInformationScreen.routeName:
      final signUpMethod = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => UserInformationScreen(signUpMethod: signUpMethod),
      );

    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );

    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );

    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(
          file: file,
        ),
      );

    case StatusScreen.routeName:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
        builder: (context) => StatusScreen(
          status: status,
        ),
      );

    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );

    case ChooseLoginMethod.routeName:
      return MaterialPageRoute(
        builder: (context) => const ChooseLoginMethod(),
      );

    case DisplayAllUsers.routeName:
      return MaterialPageRoute(
        builder: (context) => const DisplayAllUsers(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const ErrorScreen(
          error: 'This page doesn\'t  exist',
        ),
      );
  }
}
