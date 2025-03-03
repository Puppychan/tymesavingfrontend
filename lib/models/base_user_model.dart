import 'package:tymesavingfrontend/common/constant/temp_constant.dart';

class UserBase {
  final String id;
  final String username;
  final String email;
  final String fullname;
  final String phone;
  final String? avatar;
  final String rank;
  final int userPoint;

  UserBase.fromMap(Map<String, dynamic> user)
      : id = user['_id'],
        username = user['username'],
        email = user['email'],
        fullname = user['fullname'],
        phone = user['phone'],
        avatar = user['avatar'] ?? TEMP_AVATAR_IMAGE,
        rank = user['tymeReward'],
        userPoint = user['userPoints'];


  Map<String, dynamic> toMap() {
    // we are using the map to send the data to the API
    return {
      "_id": id,
      "username": username,
      "email": email,
      "fullname": fullname,
      "phone": phone,
      "avatar": avatar,
      "tymeReward": rank,
      "userPoints": userPoint,
      // "contribution": contribution,
    };
  }

  Map<String, dynamic> getOtherFields() {
    return {};
  }
}
