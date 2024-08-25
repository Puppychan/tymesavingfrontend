class MomoPaymentResponse {
  bool? isSuccess;
  int status;
  String? token;
  String? phoneNumber;
  String? data;
  String? message;
  String? extra;

  MomoPaymentResponse(this.isSuccess, this.status, this.token, this.phoneNumber, this.message, this.data, this.extra);

  static MomoPaymentResponse fromMap(Map<dynamic, dynamic> map) {
    bool? isSuccess = map["isSuccess"];
    int status = int.parse(map['status'].toString());
    String? token = map["token"];
    String? phoneNumber = map["phoneNumber"];
    String? data = map["data"];
    String? message = map["message"];
    String? extra = "";
    extra = map["extra"];
    return MomoPaymentResponse(isSuccess, status, token, phoneNumber, data, message, extra);
  }
}