import 'package:tymesavingfrontend/utils/format_date.dart';

class Budget {
  String id;
  String hostedBy;
  String name;
  String description;
  double amount;
  double concurrentAmount;
  String createdDate;
  String endDate;
  List<String> participants;

  Budget({
    required this.id,
    required this.hostedBy,
    required this.name,
    required this.description,
    required this.amount,
    required this.concurrentAmount,
    required this.createdDate,
    required this.endDate,
    required this.participants,
  });

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['_id'],
      hostedBy: map['hostedBy'],
      name: map['name'],
      description: map['description'],
      amount: map['amount'].toDouble(),
      concurrentAmount: map['concurrentAmount'].toDouble(),
      createdDate: map['createdDate'],
      endDate: map['endDate'],
      participants: List<String>.from(map['participants']),
      // participants: List<IUser>.from(map['participants'].map((participant) => IUser.fromMap(participant))),
    );
  }

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
      // 'participants': participants,
      // Assuming participants is a List<String>. If participants should be converted from List<IUser>, you might need to map each IUser to its map representation.
    };
  }
}
