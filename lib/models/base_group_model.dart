class BaseGroup {
  final String id;
  final String hostedBy;
  final String name;
  final String description;
  final double amount;
  final double concurrentAmount;
  final String createdDate;
  final String endDate;


  BaseGroup.fromMap(Map<String, dynamic> map):
      id = map['_id'],
      hostedBy = map['hostedBy'],
      name = map['name'],
      description = map['description'],
      amount = map['amount'].toDouble(),
      concurrentAmount = map['concurrentAmount'].toDouble(),
      createdDate = map['createdDate'],
      endDate = map['endDate'];

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
