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

class _GroupSavingCardState extends State<GroupSavingCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.5,
      upperBound: 1.5,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
    final isOverFullProgress = currentProgress > 1.0;
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.groupSaving.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    overflow: TextOverflow.clip,  
                    ),
                    maxLines: 2,
                  ),
                  CustomAlignText(
                    text: "Created $formattedDate",
                    alignment: Alignment.center,
                    style: Theme.of(context).textTheme.bodySmall!,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                              text: currentProgress < 1.0
                                ? 'Progress'
                                : currentProgress == 1.0
                                    ? 'Completed'
                                    : 'Exceeding!',
                              style: Theme.of(context).textTheme.bodyMedium,
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
                      style: textTheme.labelLarge,
                    ),
                    TextSpan(
                      text: ' / ',
                      style: textTheme.labelLarge!.copyWith(
                        color: colorScheme.inversePrimary,
                      ),
                    ),
                    TextSpan(
                      text: formatAmountToVnd(widget.groupSaving.amount),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ]))
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Stack(
              alignment: Alignment.center,
              children: [
                // Glowing effect
                        if (isOverFullProgress)
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      center: Alignment.center,
                                      radius: _glowAnimation.value,
                                      colors: [Colors.transparent, Colors.amber.withOpacity(0.6)],
                                      stops: const [0.6, 1.0],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        // Linear Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: currentProgress.clamp(0.0, 1.0),
                            backgroundColor: colorScheme.quaternary,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              currentProgress < 1.0
                                ? colorScheme.primary.withOpacity(0.9)
                                : currentProgress == 1.0 ? const Color.fromARGB(255, 131, 230, 134) : colorScheme.inversePrimary,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  // Widget displayParticipants() {
  //   return
  // }
}
