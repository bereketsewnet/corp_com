import 'package:corp_com/features/auth/controller/auth_controller.dart';
import 'package:corp_com/features/auth/repository/auth_repository.dart';
import 'package:corp_com/features/auth/screens/choose_login_method.dart';
import 'package:corp_com/features/landing/screens.dart';
import 'package:corp_com/routher.dart';
import 'package:corp_com/screens/mobile_layout_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/utils/colors.dart';
import 'common/widgets/error.dart';
import 'common/widgets/loader.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(
            color: appBarColor,
          )),
      onGenerateRoute: (settigs) => generateRoute(settigs),
      home: ref.watch(userDataAuthProvider).when(
        data: (user) {
          if (user == null) {
            return const ChooseLoginMethod();
          }
          return const MobileLayoutScreen();
        },
        error: (err, trace) {
          return ErrorScreen(
            error: err.toString(),
          );
        },
        loading: () => const Loader(),
      ),
    );
  }
}
/*
home: const ResponsiveLayout(
        mobileScreenLayout: MobileLayoutScreen(),
        webScreenLayout: WebLayoutScreen(),
      ),
 */
