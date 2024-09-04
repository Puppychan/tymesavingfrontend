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
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';

class AuthUserInvitationCard extends StatefulWidget {
  final Invitation invitation;

  const AuthUserInvitationCard({super.key, required this.invitation});

  @override
  State<AuthUserInvitationCard> createState() => _AuthUserInvitationCardState();
}

class _AuthUserInvitationCardState extends State<AuthUserInvitationCard> {
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
            contentWidget:
                detailedSummaryGroup(context, widget.invitation.summaryGroup),
          );
        },
        child: Card(
          color: widget.invitation.status == InvitationStatus.pending
              ? colorScheme.tertiary
              : colorScheme.background,
          margin: const EdgeInsets.only(bottom: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 2, // Adjust elevation for desired shadow effect
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
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
                  const SizedBox(height: 8.0),
                  CustomAlignText(
                    text:
                        "Invite from ${widget.invitation.summaryGroup?.name ?? "Loading..."}",
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
                  const SizedBox(height: 12.0),
                  if (widget.invitation.status == InvitationStatus.pending)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 10.0),
                        actionButton(textTheme, colorScheme, isAccept: true),
                        const SizedBox(width: 12.0),
                        actionButton(textTheme, colorScheme, isAccept: false),
                        const SizedBox(width: 10.0),
                      ],
                    )
                  else
                    CustomAlignText(
                      text: "Invitation Cancelled",
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.onError,
                        fontWeight: FontWeight.w600,
                      ),
                      alignment: Alignment.centerLeft,
                    )
                ],
              )),
        ));
  }

  Widget actionButton(TextTheme textTheme, ColorScheme colorScheme,
      {required bool isAccept}) {
    final displayText = isAccept ? 'Accept' : 'Decline';
    final displayStyle = isAccept
        ? textTheme.bodyMedium!.copyWith(
            color: colorScheme.onInverseSurface, fontWeight: FontWeight.w600)
        : textTheme.bodyMedium!.copyWith(
            color: colorScheme.secondary, fontWeight: FontWeight.w500);
    final displayBackground =
        isAccept ? colorScheme.inversePrimary : colorScheme.tertiary;

    return Expanded(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: displayBackground,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8), // Adjust vertical padding to reduce height
            ),
            onPressed: () async {
              if (isAccept) {
                await acceptDeclineInvitation(true);
              } else {
                await acceptDeclineInvitation(false);
              }
            },
            // child: CustomAlignText(
            //   text: displayText,
            //   style: displayStyle,
            //   alignment: displayAlignment,
            // )));
            child: Text(
              displayText,
              style: displayStyle,
            )));
  }
}
