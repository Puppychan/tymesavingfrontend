import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/rank_color_enum.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class UserCard extends StatelessWidget {
  final String fullname;
  final String username;
  final String rank;
  final String? avatar;
  final int checkpointReached;
  final int progressAmount;

  const UserCard({
    super.key,
    required this.fullname,
    required this.username,
    required this.rank,
    required this.checkpointReached,
    required this.progressAmount,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        leading: avatar != null
            ? CircleAvatar(backgroundImage: NetworkImage(avatar!))
            : CircleAvatar(backgroundColor: Colors.transparent, 
            child: Icon(Icons.person_2_outlined, color: colorScheme.primary,size: 35,)),
        title: Text(username, style: Theme.of(context).textTheme.labelLarge, overflow: TextOverflow.fade),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fullname, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.fade,),
            Text(rank, 
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Rank.getRankColor(rank))
            ),
            Text("Progress ${formatAmountToVnd(double.parse(progressAmount.toString()))}"),
            Text("MileStone $checkpointReached")
          ],
        ),
      ),
    );
  }
}