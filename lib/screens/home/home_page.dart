import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/components/common/chart/custom_bar_chart.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/transaction_report.model.dart';
import 'package:tymesavingfrontend/models/user.model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  late User? user; // Assuming User is a defined model
  late ChartReport? chartReport;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final authService = Provider.of<AuthService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await authService.getCurrentUserData();
      }, () async {
        setState(() {
          user = authService.user;
        });
      });

      // Start the second task only after the first one completes
      final transactionService =
          Provider.of<TransactionService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await transactionService.getChartReport(user?.id);
      }, () async {
        setState(() {
          chartReport = transactionService.chartReport!;
          debugPrint(chartReport?.totals.toString());
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    // Called when the current route has been popped off, and the current route shows up.
    Future.microtask(() async {
      final authService = Provider.of<AuthService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await authService.getCurrentUserData();
        // return result;
      }, () async {
        setState(() {
          user = authService.user;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
        padding: AppPaddingStyles.pagePaddingIncludeSubText,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // Image.asset("assets/img/app_logo_light.svg",
          //     width: media.width * 0.5, fit: BoxFit.contain),
          CustomAlignText(
              text: 'Have a nice day!', style: AppTextStyles.subHeading),
          SizedBox(
            height: 24,
          ),

          CustomBarChart(),
        ]));
  }
}
