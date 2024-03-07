import 'package:corp_com/colors.dart';
import 'package:corp_com/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            const Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 90,
                  child: CustomButton(
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
}
