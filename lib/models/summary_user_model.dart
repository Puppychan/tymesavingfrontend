import 'package:tymesavingfrontend/models/base_user_model.dart';

class SummaryUser extends UserBase {
  // final String id;
  // final String username;
  // final String email;
  // final String fullname;
  // final String phone;

  // display inside group only
  final double? totalIncome;
  final double? totalExpense;
  final int? transactionCount;

  @override
  SummaryUser.fromMap(super.user)
      // Optional fields
      : totalIncome = (user['totalIncome'] != null)
            ? user['totalIncome'].toDouble()
            : 0.0,
        totalExpense = (user['totalExpense'] != null)
            ? user['totalExpense'].toDouble()
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
      "totalIncome": totalIncome,
      "totalExpense": totalExpense,
      "transactionCount": transactionCount,
    };
  }
}
