import 'package:corp_com/common/utils/colors.dart';
import 'package:corp_com/common/utils/utils.dart';
import 'package:corp_com/common/widgets/custom_button.dart';
import 'package:corp_com/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginWithPhoneScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';

  const LoginWithPhoneScreen({super.key});

  @override
  ConsumerState<LoginWithPhoneScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginWithPhoneScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Enter your phone number',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('CorpCom will need to verify your phone number'),
            const SizedBox(height: 10),
            TextButton(
              onPressed: showCountry,
              child: const Text('Pick Country'),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                country != null
                    ? Text('+${country!.phoneCode}')
                    : const Text('+251'),
                const SizedBox(width: 10),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: 'phone number'),
                  ),
                ),
              ],
            ),
            //SizedBox(height: size.height * 0.6),
             Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 90,
                  child: CustomButton(
                    onPressed: sendPhoneNumber,
                    text: 'Next',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // display all world country
  void showCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      // optional. Shows phone code before the country name.
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty && phoneNumber.length >= 9) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    }else{
      showSnackBar(context: context, content: 'error');
    }
  }
}
