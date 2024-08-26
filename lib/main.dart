import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';
import 'package:tymesavingfrontend/common/styles/app_theme.dart';
import 'package:tymesavingfrontend/screens/splash_screen.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/services/group_saving_service.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/theme_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';
import 'package:tymesavingfrontend/utils/global_keys.dart';
import 'dart:async';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize the NetworkService
  await NetworkService.instance.initClient();
  ThemeService();
  // runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FormStateProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => BudgetService()),
        ChangeNotifierProvider(create: (_) => GroupSavingService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => InvitationService()),
        ChangeNotifierProvider(create: (_) => TransactionService()),
        ChangeNotifierProvider(create: (_) => ChallengeService()),
      ],
      child: GlobalLoaderOverlay(
        useDefaultLoading: true,
        overlayColor: AppColors.primaryBlue.withOpacity(0.5),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: Provider.of<ThemeService>(context).themeMode,
      navigatorObservers: [routeObserver],
      // home: LoaderOverlay(
      //   useDefaultLoading: true,
      //   overlayColor: AppColors.cream.withOpacity(0.7),
      //   child: const SplashScreen(),
      // ),
      home: const SplashScreen(),
      // home: MomoPaymentResultPage(momoResponse: MomoPaymentResponse.fromMap(
      //   {
      //     "partnerCode": "MOMO",
      //     "orderId": "123456",
      //     "requestId": "123456",
      //     "amount": "1000",
      //     "orderInfo": "Payment for goods",
      //     "orderType": "goods",
      //     "transId": "123456",
      //     "resultCode": "0",
      //     "message": "Success",
      //     "payType": "momo",
      //     "responseTime": "12345678"
      //   }
      // ),),
    );
  }
}
