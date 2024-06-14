import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/chart/custom_bar_chart.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_screen.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/transaction_report_model.dart';
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
  ChartReport? chartReport;
  ChartReport? chartReportSecondary;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      final authService = Provider.of<AuthService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await authService.getCurrentUserData();
      }, () async {
        setState(() {
          user = authService.user;
        });
      });

      // Start the second task only after the first one completes
      if (!mounted) return;
      final transactionService =
          Provider.of<TransactionService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await transactionService.getBothChartReport(user?.id);
      }, () async {
        setState(() {
          chartReport = transactionService.chartReport!;
          chartReportSecondary = transactionService.chartReportSecondary!;
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
      if (mounted) {
        final authService = Provider.of<AuthService>(context, listen: false);
        await handleMainPageApi(context, () async {
          return await authService.getCurrentUserData();
          // return result;
        }, () async {
          setState(() {
            user = authService.user;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: AppPaddingStyles.pagePaddingIncludeSubText,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // Image.asset("assets/img/app_logo_light.svg",
          //     width: media.width * 0.5, fit: BoxFit.contain),
          CustomAlignText(
              text: 'Have a nice day!',
              style: Theme.of(context).textTheme.headlineMedium!),
          const SizedBox(
            height: 24,
          ),
          if (chartReport == null || chartReportSecondary == null)
            // Display a loading indicator or placeholder widget
            const CircularProgressIndicator()
          else
            CustomBarChart(
              totalsExpense: chartReport!.totals,
              totalsIncome: chartReportSecondary!.totals,
            ),
          const SizedBox(height: 24), // Add some spacing between sections
          SizedBox(
            height: 500, // Adjust height as needed
            child: TransactionScreen(),
          ),
        ]));
  }
}
