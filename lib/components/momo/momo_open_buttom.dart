import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/momo/momo_payment_info_model.dart';
import 'package:tymesavingfrontend/services/momo_payment_service.dart';

class MomoOpenButton extends StatelessWidget {
  final MomoPaymentService momo = MomoPaymentService();

  MomoOpenButton({super.key});
  void _initiateMomoPayment(BuildContext context) {
    // TODO: Replace with your own payment info - env
    final paymentInfo = MomoPaymentInfo(
      partner: 'tyme_saving_app',
      appScheme: 'yourappscheme',
      merchantName: 'Your Merchant Name',
      merchantCode: 'YourMerchantCode',
      partnerCode: 'YourPartnerCode',
      amount: 100000, // Amount in VND
      orderId: 'Order_123456',
      orderLabel: 'Order Label',
      merchantNameLabel: 'Your Merchant Label',
      fee: 0,
      description: 'Payment for transaction',
    );

    momo.on(MomoPaymentService.EVENT_PAYMENT_SUCCESS, (response) {
      // Handle success and navigate to transaction form
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => TransactionFormMain(
      //       paymentResponse: response,
      //     ),
      //   ),
      // );
    });

    momo.on(MomoPaymentService.EVENT_PAYMENT_ERROR, (response) {
      // Handle error, possibly navigate back to home page or show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Payment failed or canceled: ${response.message}')),
      );
    });

    momo.open(paymentInfo);
  }

  @override
  Widget build(BuildContext context) {
    return  Material(
      elevation: 4.0, // Adjust the elevation to control the shadow
      shape: const CircleBorder(), // Shape of the button
      child: InkWell(
        onTap: () {
          _initiateMomoPayment(context);
        },
        customBorder: const CircleBorder(), // Ensure the ripple effect is circular
        child: Container(
          padding: const EdgeInsets.all(10.0), // Adjust padding as needed
          child: Image.asset(
            "assets/img/momo_icon.png",
            width: MediaQuery.of(context).size.width * 0.13,
            height: MediaQuery.of(context).size.width * 0.13,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
