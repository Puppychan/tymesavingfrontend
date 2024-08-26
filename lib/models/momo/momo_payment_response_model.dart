class MomoPaymentResponse {
  final String partnerCode;
  final String orderId;
  final String requestId;
  final int amount;
  final String orderInfo;
  final String orderType;
  final String transId;
  final int resultCode;
  final String message;
  final String payType;
  final int responseTime;
  final String extraData;
  final String signature;
  final String? partnerUserId;
  final String? storeId;
  final String? paymentOption;
  final int?  userFee;
  // final List<dynamic>? promotionInfo;

  MomoPaymentResponse.fromMap(Map<String, dynamic> map):
      partnerCode = map['partnerCode'] ?? '',
      orderId = map['orderId'] ?? '',
      requestId = map['requestId'] ?? '',
      amount = map['amount'] != null ? int.parse(map['amount']) : 0,
      orderInfo = map['orderInfo'] ?? '',
      orderType = map['orderType'] ?? '',
      transId = map['transId'] ?? '',
      resultCode = map['resultCode'] != null ? int.parse(map['resultCode']) : 0,
      message = map['message'] ?? '',
      payType = map['payType'] ?? '',
      responseTime = map['responseTime'] != null ? int.parse(map['responseTime']) : 0,
      extraData = map['extraData'] ?? '',
      signature = map['signature'] ?? '',
      partnerUserId = map['partnerUserId'],
      storeId = map['storeId'],
      paymentOption = map['paymentOption'],
      userFee = map['userFee'] != null ? int.parse(map['userFee']) : 0;
      // promotionInfo = map['promotionInfo'];

}