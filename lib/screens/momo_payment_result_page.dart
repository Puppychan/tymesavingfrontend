import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/momo/momo_payment_response_model.dart';

class MomoPaymentResultPage extends StatelessWidget {
  final MomoPaymentResponse momoResponse;

  const MomoPaymentResultPage({Key? key, required this.momoResponse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Heading(title: "MoMo Payment Result", showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: const [
                  SizedBox(height: 20),
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Payment Successful",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Your payment was successful. You can now close this page.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
            Text(
              "Payment Details:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildDetailRow("Partner Code", momoResponse.partnerCode),
            _buildDetailRow("Order ID", momoResponse.orderId),
            _buildDetailRow("Request ID", momoResponse.requestId),
            _buildDetailRow("Amount", momoResponse.amount.toString()),
            _buildDetailRow("Order Info", momoResponse.orderInfo),
            _buildDetailRow("Order Type", momoResponse.orderType),
            _buildDetailRow("Transaction ID", momoResponse.orderId),
            _buildDetailRow("Result Code", momoResponse.resultCode.toString()),
            _buildDetailRow("Message", momoResponse.message),
            _buildDetailRow("Pay Type", momoResponse.payType),
            _buildDetailRow("Response Time", momoResponse.responseTime.toString()),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
