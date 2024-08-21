import 'dart:io';

import 'package:eventify/eventify.dart';
import 'package:flutter/services.dart';
import 'package:tymesavingfrontend/common/enum/momo_payment_status_enum.dart';
import 'package:tymesavingfrontend/models/momo/momo_payment_info_model.dart';
import 'package:tymesavingfrontend/models/momo/momo_payment_response_model.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class MomoPaymentService {
  // Event names
  static const EVENT_PAYMENT_SUCCESS = 'payment.success';
  static const EVENT_PAYMENT_ERROR = 'payment.error';

  static const MethodChannel _channel = MethodChannel('momo_integration');

  late EventEmitter _eventEmitter;

  static Future<String?> initiateMoMoPayment(String transactionId) async {
    final url = '/payment/momo'; // This is the endpoint in your backend

    final response = await NetworkService.instance.post(url, body: {
      'transactionId': transactionId,
    });

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
  

  /// Opens checkout
  void open(MomoPaymentInfo options) async {
    MomoPaymentResponse validationResult = _validateOptions(options);
    if (!validationResult.isSuccess!) {
      _handleResult(
          {'type': MomoPaymentStatus.error.value, 'data': validationResult});
      return;
    }
    var response = await _channel.invokeMethod('open', options.toJson());
    _handleResult({'data': response, 'type': response['status']});
  }

  /// Handles checkout response from platform
  void _handleResult(Map<dynamic, dynamic> response) {
    String eventName;
    dynamic payload;
    payload = MomoPaymentResponse.fromMap(response['data']);
    final responseStatus = MomoPaymentStatus.fromInt(response['type']);
    switch (responseStatus) {
      case MomoPaymentStatus.success:
        eventName = EVENT_PAYMENT_SUCCESS;
        break;
      case MomoPaymentStatus.timeout:
      case MomoPaymentStatus.cancel:
        eventName = EVENT_PAYMENT_ERROR;
        break;
      default:
        eventName = EVENT_PAYMENT_ERROR;
        payload = MomoPaymentResponse(false, MomoPaymentStatus.error.value, '',
            '', 'Lỗi không xác định', '', '');
    }
    _eventEmitter.emit(eventName, null, payload);
  }

  void on(String event, Function handler) {
    cb(event, cont) {
      handler(event.eventData);
    }

    _eventEmitter.on(event, null, cb);
  }

  void clear() {
    _eventEmitter.clear();
  }

  /// Validate payment options
  static MomoPaymentResponse _validateOptions(MomoPaymentInfo options) {
    bool error = false;
    String mes = '';
    if (options.merchantName.isEmpty) {
      mes =
          'merchantcode is required. Please check if key is present in options.';
      error = true;
    }
    if (options.partner.isEmpty) {
      mes =
          'merchantcode is required. Please check if key is present in options.';
      error = true;
    }
    if (Platform.isIOS && (options.appScheme.isEmpty)) {
      mes = 'appScheme is required. Please check if key is present in options.';
      error = true;
    }
    if (options.amount < 0) {
      mes = 'amount is required. Please check if key is present in options.';
      error = true;
    }
    if (options.description == null || options.description!.isEmpty) {
      mes =
          'description is required. Please check if key is present in options.';
      error = true;
    }
    return error
        ? MomoPaymentResponse(
            false, MomoPaymentStatus.error.value, '', '', mes, '', '')
        : MomoPaymentResponse(
            true, MomoPaymentStatus.success.value, '', '', '', '', '');
  }
}
