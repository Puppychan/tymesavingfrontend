import 'package:tymesavingfrontend/models/base_user_model.dart';

class SummaryUser extends UserBase {
  // final String id;
  // final String username;
  // final String email;
  // final String fullname;
  // final String phone;

  // display inside group only
  final double? contribution;
  final double? totalAmount;
  final int? transactionCount;

  SummaryUser.fromMap(super.user)
      // Optional fields
      : contribution = (user['contribution'] != null)
            ? user['contribution'].toDouble()
            : -1.0,
        totalAmount = (user['totalAmount'] != null)
            ? user['totalAmount'].toDouble()
            : 0.0,
        transactionCount =
            (user['transactionCount'] != null) ? user['transactionCount'] : 0,
        super.fromMap() {
    // print(
    //     'SummaryUser created with id: $id, role: $role, username: $username, email: $email, fullname: $fullname, phone: $phone, creationDate: $creationDate, pin: $pin, contribution: $contribution');
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      // in case we want to add more fields
      // "contribution": contribution,
    };
  }

  @override
  Map<String, dynamic> getOtherFields() {
    return {
      "contribution": contribution,
      "totalAmount": totalAmount,
      "transactionCount": transactionCount,
    };
  }
}
