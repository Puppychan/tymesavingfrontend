import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/button_theme_enum.dart';
import 'package:tymesavingfrontend/common/enum/momo_payment_status_enum.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/momo/momo_payment_response_model.dart';
import 'package:tymesavingfrontend/screens/main_page_layout.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class MomoPaymentResultPage extends StatelessWidget {
  final MomoPaymentResponse momoResponse;

  const MomoPaymentResultPage({super.key, required this.momoResponse});

  void _navigateHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPageLayout()),
        (_) => false);
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const Heading(
        title: "MoMo Payment Result",
        showHomeButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Divider(),
            const SizedBox(height: 20),
            ...MomoPaymentStatus.toWidgetList(context, momoResponse.resultCode),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Text("Payment Details", style: textTheme.titleMedium),
            const SizedBox(height: 10),
            GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 1.0, // Space between columns
                mainAxisSpacing: 2.0, // Space between rows
                childAspectRatio:
                    3.6, // Adjust this value to control the height of the items
              ),
              shrinkWrap:
                  true, // Ensures the grid only takes up necessary space
              physics:
                  const NeverScrollableScrollPhysics(), // Prevents scrolling within the grid
              padding: const EdgeInsets.all(10.0),
              children: [
                // Grid items
                ..._buildDetailRow(
                    context, "Transaction ID", momoResponse.orderId),
                ..._buildDetailRow(context, "Amount",
                    formatAmountToVnd(momoResponse.amount.toDouble())),
                ..._buildDetailRow(
                    context, "Transaction Info", momoResponse.orderInfo),
                ..._buildDetailRow(context, "Message", momoResponse.message),
                // ..._buildDetailRow(
                //   context,
                //   "Response Time",
                //   formatDuration(momoResponse.responseTime),
                // ),
              ],
            ),
            const SizedBox(height: 20),
            PrimaryButton(
                onPressed: () {
                  _navigateHome(context);
                },
                title: "Back to Home",
                theme: AppButtonTheme.yellowBlack),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDetailRow(BuildContext context, String title, String value) {
    return [
          Text(
            "$title: ",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(value,
                style: Theme.of(context).textTheme.bodyMedium, maxLines: 3),
          
        ];
      
  }
}
