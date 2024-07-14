import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/common/sheet/icon_text_row.dart';
import 'package:tymesavingfrontend/screens/budget/budget_update_page.dart';
import 'package:tymesavingfrontend/screens/goal/goal_update_page.dart';
import 'package:tymesavingfrontend/screens/invitation/group_pending_invitation_page.dart';
import 'package:tymesavingfrontend/screens/user_list/member_list_page.dart';

List<Widget> renderGroupHeadingActions(
    BuildContext context, bool isMember, bool isBudget, String groupId) {
  List<Widget> actions = [
    ...actionRow(context, Icons.people_rounded, 'Members', () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MemberListPage(isBudgetGroup: isBudget, groupId: groupId, isMember: isMember);
      }));
    }),
    ...actionRow(context, Icons.wallet_sharp, "View group transaction history",
        () {
      // TODO: Navigate to the transaction history page
    }),
    ...actionRow(context, FontAwesomeIcons.paperPlane, "Group Invitations", () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return GroupPendingInvitationPage(groupId: groupId, type: isBudget ? InvitationType.budget : InvitationType.savings);
      }));
    })
  ];
  // if host
  if (!isMember) {
    actions.addAll(actionRow(context, Icons.edit, "Edit group", () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        if (isBudget) {
          return BudgetUpdatePage(budgetId: groupId);
        } else {
          return GoalUpdatePage(goalId: groupId);
        }
      }));
    }));
  }
  return actions;
}

void showGroupActionBottonSheet(
    BuildContext context, bool isMember, bool isBudget, String groupId) {
  showStyledBottomSheet(
      context: context,
      title: 'Group Actions',
      // initialChildSize: 0.3,
      contentWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              renderGroupHeadingActions(context, isMember, isBudget, groupId)));
}
