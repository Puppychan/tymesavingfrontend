import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/chart/custom_bar_chart.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/components/momo/momo_open_buttom.dart';
import 'package:tymesavingfrontend/components/transaction/transaction_monthly.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/monthly_report_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/tracking_report/spend_tracking.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/screens/transaction/view_all_transaction_page.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  ChartReport? chartReport;
  ChartReport? chartReportSecondary;
  Map<String, List<Transaction>>? transactions;
  bool isLoading = true;

  @override
  void initState() {
    _loadData();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _precacheImages();
    });
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _precacheImages() {
  List<String> imageUrls = [
    (widget.user!.avatar!),
    'https://drive.google.com/uc?export=view&id=1cXnNS5h14Mg8MKMCd3aHbXjkzD6kSiCF',
    'https://drive.google.com/uc?export=view&id=1j8BYbqBzCDZRgpScfYnOpdgDywZUIQMf',
    'https://drive.google.com/uc?export=view&id=1cTk-48jLV8xrQsqM1CAni5tEcHIM7sUL',
    'https://ca.slack-edge.com/T05N3DA83HS-U072X8UFLDB-g82ba8e5573d-512',
    'https://drive.google.com/uc?export=view&id=1EGFt1PwhTPx0dWEB6hssFPvv03Io_Iy8',
    'https://drive.google.com/uc?export=view&id=17rB-Cd3uJsrJ8KPXUZTdKGLeaRzEAN-P',
    'https://drive.google.com/uc?export=view&id=162RjtbQLSdKT-crv-3HW0xX3KjagwW4v',
    'https://drive.google.com/uc?export=view&id=1-veQV1CAnJmBKOm91Q6JW117axEzRnmV',
    'https://drive.google.com/uc?export=view&id=1Jx91cgkQNN4mcwHqnnQJvwFIHIdpL2yV',
    'https://drive.google.com/uc?export=view&id=12rAfSJhf3sUdQDNZdxYIcJ4tv7FOWZOb',
    'https://drive.google.com/uc?export=view&id=18wfpepyhElFLO7YeGBNyegaVwxlb0uf2',
    'https://drive.google.com/uc?export=view&id=1ci4hB6C8JvOxyVV0jTPzuyALBv3GLUzr',
  ];

  for (String url in imageUrls) {
    final image = NetworkImage(url);
      precacheImage(image, context).then((_) {
        debugPrint('Pre-cached image: $url');
      }).catchError((error) {
        debugPrint('Failed to pre-cache image: $url. Error: $error');
      });
  }
  // precacheImage(NetworkImage(), context);
}

  void _loadData() {
    setState(() {
      isLoading = true;
    });
    Future.microtask(() async {
      final transactionService =
          Provider.of<TransactionService>(context, listen: false);
      if (widget.user != null) {
        await handleMainPageApi(context, () async {
          return await transactionService.getBothChartReport(widget.user!.id);
        }, () async {
          setState(() {
            chartReport = transactionService.chartReport;
            chartReportSecondary = transactionService.chartReportSecondary;
            precacheImage(NetworkImage(widget.user!.avatar!), context);
          });
        });
        if (!mounted) return;
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
    routeObserver.unsubscribe(this);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _loadData();
    routeObserver.unsubscribe(this);
  }

  void _navigateToAllTransactions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ViewAllTransactionsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          isLoading = true;
        });
        _loadData();
      },
      child: SingleChildScrollView(
        padding: AppPaddingStyles.pagePaddingIncludeSubText,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset("assets/img/app_logo_light.svg",
            //     width: media.width * 0.5, fit: BoxFit.contain),
            //     width: media.width * 0.5, fit: BoxFit.contain),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomAlignText(
                  text: 'Have a nice day!',
                  style: Theme.of(context).textTheme.headlineMedium!,
                ),
                MomoOpenButton(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (chartReport == null && chartReportSecondary == null)
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text("No data available for chart",
                      style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: 16),
                ],
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.tertiary,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SpendTracking()));
                  },
                  child: CustomBarChart(
                    totalsExpense: chartReport!.totals,
                    totalsIncome: chartReportSecondary!.totals,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                Text("Annotation:",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 25),
                Text("Color ", style: Theme.of(context).textTheme.bodyMedium),
                Container(
                  width: 10, // Width of the color box
                  height: 10, // Height of the color box
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary, // Color of the box
                  margin: const EdgeInsets.only(
                      right: 4), // Space between the box and the text
                ),
                Text(
                  ' indicate total expense/month',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium, // Customize your text style
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 25),
                Text("Color ", style: Theme.of(context).textTheme.bodyMedium),
                Container(
                  width: 10, // Width of the color box
                  height: 10, // Height of the color box
                  color:
                      Theme.of(context).colorScheme.primary, // Color of the box
                  margin: const EdgeInsets.only(
                      right: 4), // Space between the box and the text
                ),
                Text(
                  ' indicate total income/month',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium, // Customize your text style
                ),
              ],
            ),
            const SizedBox(height: 12), // Add some spacing between sections
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Transactions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ElevatedButton(
                  onPressed: () {
                    _navigateToAllTransactions(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    elevation: 1,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  child: Text('View detail',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              // child: TransactionSection(transactions: transactions ?? {}),
              child: TransactionMonthlyTabBar(userId: widget.user!.id),
            ),
          ],
        ),
      ),
    );
  }
}
