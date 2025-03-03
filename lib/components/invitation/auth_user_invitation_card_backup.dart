import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/components/invitation/widget_detailed_summary_group.dart';
import 'package:tymesavingfrontend/models/invitation_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AuthUserInvitationCard extends StatefulWidget {
  final Invitation invitation;

  const AuthUserInvitationCard({super.key, required this.invitation});

  @override
  State<AuthUserInvitationCard> createState() => _AuthUserInvitationCardState();
}

class _AuthUserInvitationCardState extends State<AuthUserInvitationCard> {
  bool _isDataFetched = false;
  Timer? _debounce;

  void _fetchData() async {
    if (!_isDataFetched && mounted) {

      if (mounted) {
        setState(() {
          _isDataFetched = true;
        });
      }
    }
  }

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
    }, () async {});
  }

  void _onVisibilityChanged(VisibilityInfo visibilityInfo) {
    var visiblePercentage = visibilityInfo.visibleFraction * 100;
    if (visiblePercentage > 0) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), _fetchData);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return VisibilityDetector(
        key: Key(widget.invitation.invitationId), // Ensure a unique key
        onVisibilityChanged: _onVisibilityChanged,
        child: InkWell(
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
              elevation: 1, // Adjust elevation for desired shadow effect
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(widget.invitation.type ==
                                      InvitationType.budget
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
                                fontStyle: FontStyle.italic,
                              )),
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
            )));
  }
}
