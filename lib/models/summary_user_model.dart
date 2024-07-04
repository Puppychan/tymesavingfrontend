import 'package:tymesavingfrontend/common/enum/user_role_enum.dart';

class SummaryUser {
  final String? id;
  final String username;
  final String email;
  final String fullname;
  final String phone;

  // display inside group only
  final double? contribution;
  final double? totalAmount;
  final int? transactionCount;

  SummaryUser.fromMap(Map<String, dynamic> user)
      // we are using the map to get the data from the API
      : id = user['id'] ?? "",
        username = user['username'],
        email = user['email'],
        fullname = user['fullname'],
        phone = user['phone'],
        // Optional fields
        contribution = (user['contribution'] != null)
            ? user['contribution'].toDouble()
            : -1.0,
        totalAmount = (user['totalAmount'] != null)
            ? user['totalAmount'].toDouble()
            : 0.0,
        transactionCount =
            (user['transactionCount'] != null) ? user['transactionCount'] : 0 {
    // print(
    //     'SummaryUser created with id: $id, role: $role, username: $username, email: $email, fullname: $fullname, phone: $phone, creationDate: $creationDate, pin: $pin, contribution: $contribution');
  }

  Map<String, dynamic> toMap() {
    // we are using the map to send the data to the API
    return {
      "username": username,
      "email": email,
      "fullname": fullname,
      "phone": phone,
      // "contribution": contribution,
    };
  }
}
