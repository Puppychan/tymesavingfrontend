import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/screens/splash_screen.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize the NetworkService
  await NetworkService.instance.initClient();
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
