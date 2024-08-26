import 'dart:io';

import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tymesavingfrontend/common/enum/momo_payment_status_enum.dart';
import 'package:tymesavingfrontend/models/momo/momo_payment_info_model.dart';
import 'package:tymesavingfrontend/models/momo/momo_payment_response_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class MomoPaymentService extends ChangeNotifier {

  static Future<dynamic> initiateMoMoPayment(String transactionId) async {

    final response = await NetworkService.instance.post(BackendEndpoints.momo, body: {
      'transactionId': transactionId,
    });
    debugPrint('Momo payment response: $response');

    // if (response['response'] != null && response['statusCode'] == 200) {
    //   // Assuming the payUrl is returned in the response
    //   return response['response']['payUrl'];
    // } else {
    //   // Handle error
    //   print('Failed to initiate payment: ${response['response']}');
    //   return null;
    // }
    return response;
  }

}
