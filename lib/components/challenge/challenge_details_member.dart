import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String fullname;
  final String username;
  final String rank;
  final String? avatar;

  const UserCard({
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
            : CircleAvatar(backgroundColor: Colors.transparent, 
            child: Icon(Icons.person_2_outlined, color: Theme.of(context).colorScheme.primary,size: 35,)),
        title: Text(username, style: Theme.of(context).textTheme.labelLarge,),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fullname, style: Theme.of(context).textTheme.bodyMedium,),
            const Expanded(child: SizedBox(),),
            Text(rank, style: Theme.of(context).textTheme.bodyMedium,),
          ],
        ),
      ),
    );
  }
}