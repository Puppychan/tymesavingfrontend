import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tymesavingfrontend/layouts/update_user_form.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_page.dart';
import 'package:tymesavingfrontend/screens/sign_in_page.dart';
import 'package:tymesavingfrontend/screens/user_profile/update_user_widget.dart';
import 'package:tymesavingfrontend/screens/user_profile/user_profile.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  // Initialize the NetworkService
  await NetworkService.instance.initClient();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        // home: MoreMenu(),
        home: LoaderOverlay(
      useDefaultLoading: true,
      child: SignInView(),
    ));
  }
}
