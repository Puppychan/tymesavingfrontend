
class Budget {
  String id;
  String hostedBy;
  String name;
  String description;
  double amount;
  double concurrentAmount;
  DateTime createdDate;
  DateTime endDate;
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
      createdDate: DateTime.parse(map['createdDate']),
      endDate: DateTime.parse(map['endDate']),
      participants: List<String>.from(map['participants']),
      // participants: List<IUser>.from(map['participants'].map((participant) => IUser.fromMap(participant))),
    );
  }
}
