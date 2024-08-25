import 'dart:io';

class MomoPaymentInfo {
  String partner;
  String appScheme;
  String merchantName;
  String merchantCode;
  String partnerCode;
  String merchantNameLabel;

  int amount;
  int fee;
  String? description;
  String? extra;
  String? username;
  String orderId;
  String orderLabel;

  bool isTestMode;

  MomoPaymentInfo({
    required this.appScheme,
    required this.merchantName,
    required this.merchantCode,
    required this.partnerCode,
    required this.amount,
    required this.orderId,
    required this.orderLabel,
    required this.partner,
    required this.merchantNameLabel,
    required this.fee,
    this.description,
    this.username,
    this.extra,
    this.isTestMode = false,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "merchantname": merchantName,
      "merchantcode": merchantCode,
      "partnercode": partnerCode,
      "amount": amount,
      "orderid": orderId,
      "orderlabel": orderLabel,
      "partner": partner,
      "fee": fee,
      "isTestMode": isTestMode,
      "merchantnamelabel": merchantNameLabel
    };
    if (Platform.isIOS) {
      json["appScheme"] = appScheme;
    }
    if (description != null) {
      json["description"] = description;
    }
    if (username != null) {
      json["username"] = username;
    }
    if (extra != null) {
      json["extra"] = extra;
    }
    return json;
  }
}