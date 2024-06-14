import 'package:tymesavingfrontend/common/enum/invitation_type.enum.dart';
import 'package:tymesavingfrontend/common/enum/user_role_enum.dart';
import 'package:tymesavingfrontend/user.dart';

class Invitation {
  // please note that we get all these data from the API we are using
  final String id;
  final String code;
  final String description;
  final InvitationType type;
  final String groupId;
  final List<User>? user;

  // final String email;
  // final String fullname;
  // final String phone;
  // final String pin;


  Invitation.fromMap(Map<String, dynamic> invitation)
  // we are using the map to get the data from the API
      : id = invitation['_id'],
        fullname = invitation['fullname'],
        email = invitation['email'],
        phone = invitation['phone'],
        username = invitation['username'],
        role = UserRole.fromString(invitation['role']);

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
