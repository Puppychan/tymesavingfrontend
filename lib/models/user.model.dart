import 'package:tymesavingfrontend/common/user_role.enum.dart';

class User {
  // please note that we get all these data from the API we are using
  final String id;
  final String fullname;
  final String email;
  final String phone;
  final String username;
  final UserRole role;

  User.fromMap(Map<String, dynamic> user)
      : id = user['_id'],
        fullname = user['fullname'],
        email = user['email'],
        phone = user['phone'],
        username = user['username'],
        role = UserRole.fromString(user['role']);

  Map<String, dynamic> toMap() {
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
