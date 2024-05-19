import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/local_storage_key.constant.dart';
import 'package:tymesavingfrontend/layouts/update_user_form.dart';
import 'package:tymesavingfrontend/screens/HomePage.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_page.dart';
import 'package:tymesavingfrontend/screens/sign_in_page.dart';
import 'package:tymesavingfrontend/screens/splash_screen.dart';
import 'package:tymesavingfrontend/screens/user_profile/update_user_widget.dart';
import 'package:tymesavingfrontend/screens/user_profile/user_profile.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/utils/local_storage_service.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize the NetworkService
  await NetworkService.instance.initClient();
  final token = await LocalStorageService.getString(LOCAL_AUTH_TOKEN);
  print("Token inside main: $token");
  // runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context, listen: false);
    // await authService.tryAutoLogin();

    // return FutureBuilder(
    //   future: authService.tryAutoLogin(),
    //   builder: (ctx, snapshot) =>
    //       snapshot.connectionState == ConnectionState.waiting
    //           ? const SplashScreen()
    //           : MaterialApp(
    //               title: 'My App',
    //               theme: ThemeData(
    //                 primarySwatch: Colors.blue,
    //               ),
    //               home: snapshot.hasData && snapshot.data == true
    //                   ? const HomePage(
    //                       title: 'Hello',
    //                     )
    //                   : const SignInView(),
    //             ),
    // );
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: AppColors.primaryBlue),
      ),
      home: LoaderOverlay(
        useDefaultLoading: true,
        overlayColor: AppColors.cream.withOpacity(0.7),
        child: const SplashScreen(),
      ),
    );
  }
}
 