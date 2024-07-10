import 'package:tymesavingfrontend/common/enum/user_role_enum.dart';
import 'package:tymesavingfrontend/models/base_user_model.dart';

class User extends UserBase {
  // please note that we get all these data from the API we are using
  // final String id;
  // final String username;
  // final String email;
  // final String fullname;
  // final String phone;
  // final String? avatar;
  final UserRole role;
  final String creationDate;

  // optional
  final String? pin;

  @override
  User.fromMap(super.user)
      // we are using the map to get the data from the API
      : role = UserRole.fromString(user['role']),
        creationDate = user['creationDate'],
        // Optional fields
        pin = (user['pin'] != null) ? user['pin'] : "",
        super.fromMap() {
    // print(
    //     'User created with id: $id, role: $role, username: $username, email: $email, fullname: $fullname, phone: $phone, creationDate: $creationDate, pin: $pin, contribution: $contribution');
  }

  @override
  Map<String, dynamic> getOtherFields() {
    // we are using the map to send the data to the API
    return {
      "role": role.toString(),
      "creationDate": creationDate,
      "pin": pin,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    // we are using the map to send the data to the API
    return {
      ...super.toMap(),
      "role": role.toString(),
      "pin": pin,
      "creationDate": creationDate,
    };
  }
}
