import 'package:corp_com/common/widgets/error.dart';
import 'package:corp_com/features/auth/screens/login_screen.dart';
import 'package:corp_com/features/auth/screens/otp_screen.dart';
import 'package:corp_com/screens/mobile_chat_screen.dart';
import 'package:flutter/material.dart';

import 'features/auth/screens/user_information_screen.dart';
import 'features/select_contacts/screens/select_contacts_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );

    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );

    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => const MobileChatScreen(),
      );

    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );

    // case ConfirmStatusScreen.routeName:
    //   final file = settings.arguments as File;
    //   return MaterialPageRoute(
    //     builder: (context) => ConfirmStatusScreen(
    //       file: file,
    //     ),
    //   );

    // case StatusScreen.routeName:
    //   final status = settings.arguments as Status;
    //   return MaterialPageRoute(
    //     builder: (context) => StatusScreen(
    //       status: status,
    //     ),
    //   );

    // case CreateGroupScreen.routeName:
    //   return MaterialPageRoute(
    //     builder: (context) => const CreateGroupScreen(),
    //   );
    //
    default:
      return MaterialPageRoute(
        builder: (context) => const ErrorScreen(
          error: 'This page doesn\'t  exist',
        ),
      );
  }
}