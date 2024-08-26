import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:url_launcher/url_launcher.dart';

class MoMoPaymentPage extends StatefulWidget {
  final String paymentUrl;
  final String transactionId;

  const MoMoPaymentPage(
      {super.key, required this.paymentUrl, required this.transactionId});

  @override
  State<MoMoPaymentPage> createState() => _MoMoPaymentPageState();
}

class _MoMoPaymentPageState extends State<MoMoPaymentPage> {
  @override
  void initState() {
    super.initState();
    _launchMoMoApp();
  }

  void _launchMoMoApp() {
    Future.microtask(() async {
      try {
        // // Attempt to launch the MoMo app using the deeplink
        final linkUri = Uri.parse(widget.paymentUrl);
        // print("Launching MoMo app with deeplink: $linkUri");
        if (await canLaunchUrl(linkUri)) {
          await launchUrl(linkUri, mode: LaunchMode.externalApplication);
        } else {
          if (!mounted) return;
          Provider.of<TransactionService>(context, listen: false)
              .deleteTransaction(widget.transactionId);
          ErrorDisplay.showErrorToast("Error launching Momo page", context);
        }
      } catch (e) {
        if (!mounted) return;
        //
        Provider.of<TransactionService>(context, listen: false)
            .deleteTransaction(widget.transactionId);
        ErrorDisplay.showErrorToast("Error launching Momo page", context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Heading(title: "MoMo Payment", showBackButton: true),
        body: Center(
            child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              "Please wait while we redirect you to the MoMo app...",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        )));
  }
}
