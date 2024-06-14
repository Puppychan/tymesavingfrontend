import 'package:tymesavingfrontend/common/enum/user_role_enum.dart';

class User {
  // please note that we get all these data from the API we are using
  final String id;
  final UserRole role;
  final String username;
  final String email;
  final String fullname;
  final String phone;
  final String pin;


  User.fromMap(Map<String, dynamic> user)
  // we are using the map to get the data from the API
      : id = user['_id'],
        fullname = user['fullname'],
        email = user['email'],
        phone = user['phone'],
        username = user['username'],
        role = UserRole.fromString(user['role']);

  Map<String, dynamic> toMap() {
    // we are using the map to send the data to the API
    return {
      "_id": id,
      "fullname": fullname,
      "email": email,
      "phone": phone,
      "username": username,
      "role": role.toString(),
    };
  }


}
