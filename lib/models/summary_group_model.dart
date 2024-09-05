class SummaryGroup {
  String name;
  String description;
  String hostUsername;
  String? hostFullName;
  int memberCount;
  String createdDate;

  SummaryGroup({
    required this.name,
    required this.description,
    required this.hostUsername,
    required this.memberCount,
    required this.createdDate,
    this.hostFullName,
  });

  factory SummaryGroup.fromMap(Map<String, dynamic> map) {
    return SummaryGroup(
      name: map['name'],
      description: map['description'],
      hostUsername: map['hostUsername'],
      memberCount: map['memberCount'],
      createdDate: map['createdDate'],
      hostFullName: map['hostFullName'] ?? '',
    );
  }

  // Map<String, dynamic> toMapForForm() {
  //   return {
  //     'id': id,
  //     'hostedBy': hostedBy,
  //     'name': name,
  //     'description': description,
  //     'amount': amount,
  //     'concurrentAmount': concurrentAmount,
  //     'createdDate': createdDate,
  //     'endDate': endDate,
  //     // 'participants': participants,
  //     // Assuming participants is a List<String>. If participants should be converted from List<IUser>, you might need to map each IUser to its map representation.
  //   };
  // }
}
