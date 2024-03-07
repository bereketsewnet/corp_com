import 'package:corp_com/colors.dart';
import 'package:corp_com/common/widgets/custom_button.dart';
import 'package:corp_com/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Welcome to CorpCom',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: size.height / 25),
            Image.asset(
              'assets/backgroundImage.png',
              height: 340,
              width: 340,
              color: tabColor,
            ),
            SizedBox(height: size.height / 25),
            const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                'Read our Privacy Policy. Tap"Agree and continue" to accept the Terms of Service.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
             CustomButton(
              text: 'Agree and Continue',
              onPressed: () => navigateToLoginScreen(context),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }
}
