import 'package:corp_com/common/widgets/error.dart';
import 'package:corp_com/features/auth/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const ErrorScreen(
          error: 'This page doesn\'t  exist',
        ),
      );
  }
}
