import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/components/group_saving/group_saving_details.dart';
import 'package:tymesavingfrontend/models/group_saving_model.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:timeago/timeago.dart' as timeago;

// final tempGroupSaving = GroupSaving(
//   id: "1",
//   hostedBy: "72e4b93000be75dd6e367723",
//   name: 'GroupSaving Name',
//   description: 'Description',
//   amount: 50000000,
//   concurrentAmount: 10000000,
//   createdDate: DateTime.now().toString(),
//   endDate: DateTime.now().add(const Duration(days: 30)).toString(),
//   participants: [],
// );

class GroupSavingCard extends StatefulWidget {
  // final String groupSavingId;
  final GroupSaving groupSaving;
  const GroupSavingCard({super.key, required this.groupSaving});
  @override
  State<GroupSavingCard> createState() => _GroupSavingCardState();
}

class _GroupSavingCardState extends State<GroupSavingCard> {
  @override
  Widget build(BuildContext context) {
    // final groupSaving = Provider.of<AuthService>(context).groupSaving;
    // final groupSaving = tempGroupSaving;
    final currentProgress =
        widget.groupSaving.concurrentAmount / widget.groupSaving.amount;

    // double progress = groupSaving.contribution / maxContribution; // Calculate the progress as a fraction
    String formattedDate = timeago
        .format(DateTime.parse(widget.groupSaving.createdDate.toString()));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: colorScheme.tertiary,
      shadowColor: colorScheme.shadow,
      elevation: 5,
      child: InkWell(
        splashColor: colorScheme.quaternary,
        onTap: () {
          // debugPrint('Challenge tapped.');
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return GroupSavingDetails(groupSavingId: widget.groupSaving.id);
          }));
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CustomCircleAvatar(imagePath: groupSaving.avatarPath),
                  // const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.groupSaving.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Expanded(
                    child: CustomAlignText(
                      text: "Created $formattedDate",
                      alignment: Alignment.centerRight,
                      style: Theme.of(context).textTheme.bodySmall!,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      flex: 6,
                      child: Text.rich(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Progress ',
                              style: Theme.of(context).textTheme.bodyMedium!,
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(width: 3),
                  Text.rich(TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: formatAmountToVnd(
                          widget.groupSaving.concurrentAmount),
                      // text: "GroupSaving Contribution",
                      style: textTheme.bodyLarge,
                    ),
                    TextSpan(
                      text: ' / ',
                      style: textTheme.labelLarge!.copyWith(
                        color: colorScheme.inversePrimary,
                      ),
                    ),
                    TextSpan(
                      text: formatAmountToVnd(widget.groupSaving.amount),
                      style: Theme.of(context).textTheme.bodyMedium!,
                    ),
                  ]))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: currentProgress.clamp(
                      0.0, 1.0), // Ensuring the value is between 0 and 1
                  // value: 0.4, // Ensuring the value is between 0 and 1
                  backgroundColor: colorScheme.quaternary,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  minHeight: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget displayParticipants() {
  //   return
  // }
}
