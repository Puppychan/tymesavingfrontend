import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
      color: colorScheme.tertiary,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 1,
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
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Total Achieved: ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: formatAmountToVnd(double.parse(progressAmount.toString())),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary, // Example of custom styling
                        ),
                  ),
                ],
              ),
            ),
            Text(checkpointReached == 0 ?
              "No milestone reached" :
              "Reached milestone $checkpointReached",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic,)
            )
          ],
        ),
      ),
    );
  }
}