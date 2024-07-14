import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/invitation_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/models/invitation_model.dart';
import 'package:tymesavingfrontend/models/summary_group_model.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/goal_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GroupInvitationCard extends StatefulWidget {
  final Invitation invitation;

  const GroupInvitationCard({super.key, required this.invitation});

  @override
  State<GroupInvitationCard> createState() => _GroupInvitationCardState();
}

class _GroupInvitationCardState extends State<GroupInvitationCard> {
  bool _isDataFetched = false;
  SummaryGroup? groupSummary;
  SummaryUser? summaryUser;
  Timer? _debounce;

  void _fetchData() async {
    if (!_isDataFetched && mounted) {
      // Fetch group details
      await handleMainPageApi(context, () async {
        if (widget.invitation.type == InvitationType.budget) {
          // Fetch budget details
          return await Provider.of<BudgetService>(context, listen: false)
              .fetchBudgetSummary(widget.invitation.groupId);
        } else if (widget.invitation.type == InvitationType.savings) {
          // Fetch goal details
          return await Provider.of<GoalService>(context, listen: false)
              .fetchGoalSummary(widget.invitation.groupId);
        }
      }, () async {
        setState(() {
          groupSummary =
              Provider.of<BudgetService>(context, listen: false).summaryGroup;
        });
      });

      if (mounted) {
        setState(() {
          _isDataFetched = true;
        });
      }
    }
  }

  Future<SummaryUser?> _fetchUserData(String userId) async {
    SummaryUser? user;
    await handleMainPageApi(context, () async {
      return await Provider.of<UserService>(context, listen: false)
          .getOtherUserInfo(userId);
    }, () async {
      user = Provider.of<UserService>(context, listen: false).summaryUser;
    });
    return user;
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
              // showStyledBottomSheet(
              //   context: context,
              //   title: widget.invitation.type.toStringFormatted(),
              //   contentWidget: detailedSummaryGroup(context, groupSummary),
              // );
            },
            child: Card(
              color: colorScheme.tertiary,
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 2, // Adjust elevation for desired shadow effect
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
                                fontFamily: "Merriweather",
                                fontStyle: FontStyle.italic,
                              )),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<SummaryUser?>(
                        future: _fetchUserData(widget.invitation.userId ?? ""),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Loading user data...",
                                style: Theme.of(context).textTheme.bodyMedium);
                          } else if (snapshot.hasError) {
                            return const Text('Error loading user data');
                          } else if (!snapshot.hasData) {
                            return const Text('User not found');
                          } else {
                            final user = snapshot.data!;
                            return RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Sent to: ",
                                      style: textTheme.bodyLarge!.copyWith(
                                        fontStyle: FontStyle.italic,
                                      )),
                                  const WidgetSpan(
                                    child: Icon(
                                        FontAwesomeIcons.personDotsFromLine,
                                        size: 18),
                                  ),
                                  TextSpan(
                                      text: "  ${user.fullname}",
                                      style: textTheme.bodyLarge),
                                  TextSpan(
                                      text: " - ${user.username}",
                                      style: textTheme.bodyLarge!.copyWith(
                                        color: colorScheme.secondary,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400,
                                      )),
                                ],
                              ),
                            );
                          }
                        },
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
            )));
  }
}
