import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/momo/momo_transaction_sheet.dart';
import 'package:tymesavingfrontend/services/momo_payment_service.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class MomoOpenButton extends StatelessWidget {
  final MomoPaymentService momo = MomoPaymentService();

  MomoOpenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  Material(
      elevation: 4.0, // Adjust the elevation to control the shadow
      shape: const CircleBorder(), // Shape of the button
      child: InkWell(
        onTap: () {
          // _initiateMomoPayment(context);
          showMomoOption(context);
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
