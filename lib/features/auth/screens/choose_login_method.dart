import 'package:corp_com/common/utils/utils.dart';
import 'package:corp_com/features/auth/controller/auth_controller.dart';
import 'package:corp_com/features/auth/screens/login_with_phone_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/error.dart';
import '../../../common/widgets/loader.dart';
import '../widgets/my_button.dart';
import '../widgets/my_textfield.dart';
import '../widgets/square_tile.dart';

class ChooseLoginMethod extends ConsumerWidget {
  static const routeName = '/choose-login-method';

  const ChooseLoginMethod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // text editing controllers
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // sign user in method
    void signUpWithEmail() {
      String email, password;

      email = emailController.text.trim();
      password = passwordController.text.trim();
      if (email.isNotEmpty && password.isNotEmpty && password.length > 5) {
        ref.read(authControllerProvider).signUpWithEmailAndPassword(
              email,
              password,
              context,
            );
      } else {
        showSnackBar(context: context, content: 'Error');
      }
    }

    void signInWithEmail() {
      String email, password;

      email = emailController.text.trim();
      password = passwordController.text.trim();
      if (email.isNotEmpty && password.isNotEmpty && password.length > 5) {
        ref.read(authControllerProvider).signInWithEmailAndPassword(
              email,
              password,
              context,
            );
      } else {
        showSnackBar(context: context, content: 'Error');
      }
    }

    signInWithGoogle(BuildContext context) async{
    final user = await ref.read(authControllerProvider).signInWithGoogle(context);
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 30),

                // welcome back, you've been missed!
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  // onTap: signUpWithEmail,
                  onTap: () {
                    ref.watch(userDataAuthProvider).when(
                          data: (user) {
                            if (user == null) {
                              signInWithEmail();
                            } else {
                              signUpWithEmail();
                            }
                          },
                          error: (err, trace) {
                            const ErrorScreen();
                          },
                          loading: () => const Loader(),
                        );
                  },
                ),

                const SizedBox(height: 30),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(
                      imagePath: 'assets/google.png',
                      onTap: () {
                        signInWithGoogle(context);
                      },
                    ),

                    const SizedBox(width: 25),

                    // apple button
                    SquareTile(
                      imagePath: 'assets/apple.png',
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          LoginWithPhoneScreen.routeName,
                        );
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
