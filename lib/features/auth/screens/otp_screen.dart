import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  static const String routeName = '/otp-screen';
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
