import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/momo/momo_payment_response_model.dart';
import 'package:tymesavingfrontend/screens/momo_payment_result_page.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

class MoMoPaymentPage extends StatefulWidget {
  final String paymentUrl;
  final String transactionId;

  const MoMoPaymentPage(
      {super.key, required this.paymentUrl, required this.transactionId});

  @override
  State<MoMoPaymentPage> createState() => _MoMoPaymentPageState();
}

class _MoMoPaymentPageState extends State<MoMoPaymentPage> {
  StreamSubscription? _sub;
  @override
  void initState() {
    super.initState();
    _launchMoMoApp();
    _handleIncomingLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleIncomingLinks() {
    // Handle incoming deep links
    _sub = uriLinkStream.listen((Uri? listenedUri) {
      if (listenedUri != null) {
        // Check if the URI matches the success path
        print(
            "URI Path is: ${listenedUri} - ${listenedUri.host} - ${listenedUri.path} - ${listenedUri.query}");
        // Check if the URI path matches 'payment/momo'
        if (listenedUri.host == 'payment' && listenedUri.path == '/momo') {
          print("Payment URI: ${listenedUri.queryParameters}");
          final momoResult =
              MomoPaymentResponse.fromMap(listenedUri.queryParameters);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MomoPaymentResultPage(momoResponse: momoResult),
              ),
              (_) => false);
        }
      }
    }, onError: (err) {
      // Handle errors by showing an error screen, etc.
    });
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
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/momo_logo.png",
                      width: 100,
                      height: 100,
                    ),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      "Please wait while we redirect you to the MoMo app...",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ],
                ))));
  }
}
