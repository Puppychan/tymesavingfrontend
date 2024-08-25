import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoMoPaymentPage extends StatefulWidget {
  final String paymentUrl;
  final String deeplink;

  const MoMoPaymentPage(
      {super.key, required this.paymentUrl, required this.deeplink});

  @override
  State<MoMoPaymentPage> createState() => _MoMoPaymentPageState();
}

class _MoMoPaymentPageState extends State<MoMoPaymentPage> {
  late final WebViewController controller;
  bool isHaveMomo = true;

  @override
  void initState() {
    super.initState();
    _launchMoMoApp();
  }

  void _defineWebViewController() {
    controller = WebViewController();
    // Attempt to load the page after WebView is initialized
    Future.microtask(() {
      controller.loadRequest(
        Uri.parse(widget.paymentUrl),
      );
    });
  }

  void _launchMoMoApp() {
    Future.microtask(() async {
      print("Launching MoMo app...");
      try {
        // // Attempt to launch the MoMo app using the deeplink
        final linkUri = Uri.parse(widget.paymentUrl);
        // print("Launching MoMo app with deeplink: $linkUri");
        if (await canLaunchUrl(linkUri)) {
          print("MoMo app is available. Launching...");
          setState(() {
            isHaveMomo = true;
          });
          await launchUrl(linkUri, mode: LaunchMode.externalApplication);
        } else {
          print("MoMo app is not available. Loading payment URL in WebView...");
          setState(() {
            isHaveMomo = false;
          });
          // If MoMo app is not available, load the payment URL in WebView
          _defineWebViewController();
        }
        // print("MoMo app is not available. Loading payment URL in WebView...");
        // setState(() {
        //   isHaveMomo = false;
        // });
        // If MoMo app is not available, load the payment URL in WebView
        // _defineWebViewController();
      } catch (e) {
        print("Error launching MoMo app: $e");
        setState(() {
          isHaveMomo = false;
        });
        // Fallback to WebView if any error occurs
        _defineWebViewController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Heading(title: "MoMo Payment", showBackButton: true),
      body: isHaveMomo
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : WebViewWidget(
              controller: controller,
            ),
    );
  }
}
