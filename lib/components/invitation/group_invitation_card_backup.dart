import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tymesavingfrontend/common/enum/invitation_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/models/invitation_model.dart';


class GroupInvitationCard extends StatefulWidget {
  final Invitation invitation;

  const GroupInvitationCard({super.key, required this.invitation});

  @override
  State<GroupInvitationCard> createState() => _GroupInvitationCardState();
}

class _GroupInvitationCardState extends State<GroupInvitationCard> {
  bool _isDataFetched = false;

  void _fetchData() async {
    if (!_isDataFetched && mounted) {
      if (mounted) {
        setState(() {
          _isDataFetched = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Slidable(
        key: ValueKey(widget.invitation.code),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            // Perform the remove action
            // widget.onRemove();
          },
        ),
        children: [
          SlidableAction(
            onPressed: (context) {
              // widget.onRemove(); // Action for removing the card
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Remove',
          ),
        ],
      ),
        child: Card(
          color: colorScheme.tertiary,
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 1, // Adjust elevation for desired shadow effect
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(widget.invitation.type == InvitationType.budget
                              ? Icons.savings
                              : Icons.assessment),
                          const SizedBox(width: 5.0),
                          Text(widget.invitation.type.toStringFormatted(),
                              style: textTheme.bodyLarge),
                          const SizedBox(width: 5.0),
                          Icon(
                            Icons.circle_rounded,
                            size: 18,
                            color: widget.invitation.status ==
                                    InvitationStatus.pending
                                ? colorScheme.inversePrimary
                                : colorScheme.error,
                          )
                        ],
                      ),
                      Text(widget.invitation.code,
                          style: textTheme.bodyMedium!.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Sent to: ",
                                  style: textTheme.bodyLarge!.copyWith(
                                    fontStyle: FontStyle.italic,
                                  )),
                              const WidgetSpan(
                                child: Icon(FontAwesomeIcons.personDotsFromLine,
                                    size: 18),
                              ),
                              TextSpan(
                                  text: "  ${widget.invitation.userFullName}",
                                  style: textTheme.bodyLarge),
                              TextSpan(
                                  text: " - ${widget.invitation.userUserName}",
                                  style: textTheme.bodyLarge!.copyWith(
                                    color: colorScheme.secondary,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                        ),
                  const SizedBox(height: 16.0),
                  CustomAlignText(
                    text: "\" ${widget.invitation.description} \"",
                    style: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                  ),
                ],
              )),
        ));
  }
}
