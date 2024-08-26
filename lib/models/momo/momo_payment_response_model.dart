import 'dart:ffi';

class MomoPaymentResponse {
  final String partnerCode;
  final String orderId;
  final String requestId;
  final Long amount;
  final String orderInfo;
  final String orderType;
  final String transId;
  final int resultCode;
  final String message;
  final String payType;
  final Long responseTime;
  final String extraData;
  final String signature;
  final String? partnerUserId;
  final String? storeId;
  final String? paymentOption;
  final Long?  userFee;
  // final List<dynamic>? promotionInfo;

  MomoPaymentResponse.fromMap(Map<String, dynamic> map):
      partnerCode = map['partnerCode'] ?? '',
      orderId = map['orderId'] ?? '',
      requestId = map['requestId'] ?? '',
      amount = map['amount'] ?? '',
      orderInfo = map['orderInfo'] ?? '',
      orderType = map['orderType'] ?? '',
      transId = map['transId'] ?? '',
      resultCode = map['resultCode'] ?? '',
      message = map['message'] ?? '',
      payType = map['payType'] ?? '',
      responseTime = map['responseTime'] ?? '',
      extraData = map['extraData'] ?? '',
      signature = map['signature'] ?? '',
      partnerUserId = map['partnerUserId'],
      storeId = map['storeId'],
      paymentOption = map['paymentOption'],
      userFee = map['userFee'];
      // promotionInfo = map['promotionInfo'];

}