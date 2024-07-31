import 'package:flutter/material.dart';

class SimpleCard extends StatelessWidget {
  final String fullname;
  final String username;
  final String rank;
  final String? avatar;

  const SimpleCard({
    super.key,
    required this.fullname,
    required this.username,
    required this.rank,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        leading: avatar != null
            ? CircleAvatar(backgroundImage: NetworkImage(avatar!))
            : const CircleAvatar(child: Icon(Icons.person)),
        title: Text(username),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fullname),
          ],
        ),
      ),
    );
  }
}