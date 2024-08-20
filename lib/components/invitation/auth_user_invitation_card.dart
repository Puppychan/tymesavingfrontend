import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/invitation_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/components/invitation/widget_detailed_summary_group.dart';
import 'package:tymesavingfrontend/models/invitation_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class AuthUserInvitationCard extends StatefulWidget {
  final Invitation invitation;

  const AuthUserInvitationCard({super.key, required this.invitation});

  @override
  State<AuthUserInvitationCard> createState() => _AuthUserInvitationCardState();
}

class _AuthUserInvitationCardState extends State<AuthUserInvitationCard> {
  final bool _isDataFetched = false;


  Future<void> acceptDeclineInvitation(bool isAccept) async {
    final userId = Provider.of<AuthService>(context, listen: false).user?.id;
    await handleMainPageApi(context, () async {
      final invitationService =
          Provider.of<InvitationService>(context, listen: false);
      if (isAccept) {
        return await invitationService.acceptInvitation(
            userId ?? "", widget.invitation.invitationId);
      } else {
        return await invitationService.declineInvitation(
            userId ?? "", widget.invitation.invitationId);
      }
    }, () async {
      if (isAccept) {
        // Remove the invitation from the list
        SuccessDisplay.showSuccessToast("Invitation accepted", context);
      } else {
        // Remove the invitation from the list
        SuccessDisplay.showSuccessToast("Invitation declined", context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
        onTap: () {
          // Handle tap action
          showStyledBottomSheet(
            context: context,
            title: widget.invitation.type.toStringFormatted(),
            contentWidget: detailedSummaryGroup(context, widget.invitation.summaryGroup),
          );
        },
        child: Card(
          color: colorScheme.tertiary,
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2, // Adjust elevation for desired shadow effect
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
                              style: textTheme.bodyLarge)
                        ],
                      ),
                      Text(widget.invitation.code,
                          style: textTheme.bodyMedium!.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Merriweather",
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  CustomAlignText(
                    text: "Invite from ${widget.invitation.summaryGroup?.name ?? "Loading..."}",
                    style: textTheme.bodyLarge!.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8.0),
                  CustomAlignText(
                    text: widget.invitation.description,
                    style: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                  ),
                  if (widget.invitation.status == InvitationStatus.pending)
                    Row(
                      children: [
                        TextButton(
                          onPressed: () async {
                            await acceptDeclineInvitation(true);
                          },
                          child: Text('Accept',
                              style: textTheme.bodyMedium!.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600)),
                        ),
                        TextButton(
                            onPressed: () async {
                              await acceptDeclineInvitation(false);
                            },
                            child: Text(
                              'Decline',
                              style: textTheme.bodyMedium!.copyWith(
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.w500),
                            )),
                      ],
                    ),
                ],
              )),
        ));
  }
}
