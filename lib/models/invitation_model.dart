import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';

class Invitation {
  // please note that we get all these data from the API we are using
  final String id;
  final String code;
  final String description;
  final InvitationType type;
  final String groupId;
  // final List<User>? user;

  // final String email;
  // final String fullname;
  // final String phone;
  // final String pin;


  Invitation.fromMap(Map<String, dynamic> invitation)
  // we are using the map to get the data from the API
      : id = invitation['_id'],
        code = invitation['code'],
        description = invitation['description'],
        type = InvitationType.fromString(invitation['type']),
        groupId = invitation['groupId'];

  Map<String, dynamic> toMap() {
    // we are using the map to send the data to the API
    return {
      "_id": id,
      "code": code,
      "description": description,
      "type": type.toString(),
      "groupId": groupId,
    };
  }


}
