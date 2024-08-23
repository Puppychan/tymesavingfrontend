import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoMoPaymentPage extends StatefulWidget {
  final String paymentUrl;
  final String deepLink;

  MoMoPaymentPage({required this.paymentUrl, required this.deepLink});

  @override
  _MoMoPaymentPageState createState() => _MoMoPaymentPageState();
}

class _MoMoPaymentPageState extends State<MoMoPaymentPage> {
    late final WebViewController controller;

  @override
  void initState() {
    super.initState();
        controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.paymentUrl),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MoMo Payment'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
