import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(error ?? '404 Page not found'),
      ),
    );
  }
}
