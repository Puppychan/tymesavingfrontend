import 'package:tymesavingfrontend/common/constant/temp_constant.dart';
import 'package:tymesavingfrontend/common/enum/user_role_enum.dart';

class User {
  // please note that we get all these data from the API we are using
  final String id;
  final UserRole role;
  final String username;
  final String email;
  final String fullname;
  final String phone;

  // optional
  final String creationDate;
  final String? avatar;
  final String? pin;

  // final List<Invitation>? invitations;
  // final List<String>? sharedBudgetHosts;
  // final List<String>? joinedSharedBudgetGroups;
  // final List<String>? transactions;
  // final List<String>? groupSavingHosts;
  // final List<String>? joinedSavingGroups;
  // final List<String>? challengeParticipations;
  // final List<String>? challengeHosts;
  // final List<String>? challengeHosts;

  User.fromMap(Map<String, dynamic> user)
      // we are using the map to get the data from the API
      : id = user['_id'],
        role = UserRole.fromString(user['role']),
        username = user['username'],
        email = user['email'],
        fullname = user['fullname'],
        phone = user['phone'],
        // Optional fields
        creationDate = user['creationDate'],
        avatar = (user['avatar'] != null) ? user['avatar'] : TEMP_AVATAR_IMAGE,
        pin = (user['pin'] != null) ? user['pin'] : ""
            {
    // print(
    //     'User created with id: $id, role: $role, username: $username, email: $email, fullname: $fullname, phone: $phone, creationDate: $creationDate, pin: $pin, contribution: $contribution');
  }

  Map<String, dynamic> toMap() {
    // we are using the map to send the data to the API
    return {
      "_id": id,
      "role": role.toString(),
      "username": username,
      "email": email,
      "fullname": fullname,
      "phone": phone,
      "avatar": avatar,
      "creationDate": creationDate,
      "pin": pin,
      // "contribution": contribution,
    };
  }
}
