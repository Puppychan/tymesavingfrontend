import 'package:tymesavingfrontend/common/enum/approve_status_enum.dart';

class BaseGroup {
  final String id;
  final String hostedBy;
  final String hostByFullName;
  final String name;
  final String description;
  final double amount;
  final double concurrentAmount;
  final String createdDate;
  final String endDate;
  final ApproveStatus defaultApproveStatus;
  final bool isClosedOrExpired;


  BaseGroup.fromMap(Map<String, dynamic> map):
      id = map['_id'] ?? '',
      hostedBy = map['hostedBy'] ?? '',
      name = map['name'] ?? '',
      description = map['description'] ?? '',
      amount = (map['amount'] as num?)?.toDouble() ?? 0.0,
      concurrentAmount = (map['concurrentAmount'] as num?)?.toDouble() ?? 0.0,
      createdDate = map['createdDate'] ?? '',
      endDate = map['endDate'] ?? '',
      defaultApproveStatus = ApproveStatus.fromString(map['defaultApproveStatus']),
      isClosedOrExpired = map['isClosedOrExpired'] ?? false,
      hostByFullName = map['hostedByFullName'] ?? '';

  Map<String, dynamic> toMapForForm() {
    return {
      'id': id,
      'hostedBy': hostedBy,
      'name': name,
      'description': description,
      'amount': amount,
      'concurrentAmount': concurrentAmount,
      'createdDate': createdDate,
      'endDate': endDate,
      'defaultApproveStatus': defaultApproveStatus,
      'isClosedOrExpired': isClosedOrExpired,
      // 'participants': participants,
      // Assuming participants is a List<String>. If participants should be converted from List<IUser>, you might need to map each IUser to its map representation.
    };
  }
}
