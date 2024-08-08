import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/common/enum/page_location_enum.dart';
import 'package:tymesavingfrontend/components/common/dialog/delete_confirm_dialog.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/common/sheet/icon_text_row.dart';
import 'package:tymesavingfrontend/screens/budget/budget_update_page.dart';
import 'package:tymesavingfrontend/screens/challenge/challenge_page.dart';
import 'package:tymesavingfrontend/screens/group_saving/group_saving_update_page.dart';
import 'package:tymesavingfrontend/screens/invitation/group_pending_invitation_page.dart';
import 'package:tymesavingfrontend/screens/main_page_layout.dart';
import 'package:tymesavingfrontend/screens/user_list/member_list_page.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/group_saving_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

List<Widget> renderGroupHeadingActions(
    BuildContext context, bool isMember, bool isBudget, String groupId) {
  List<Widget> actions = [
    ...actionRow(context, Icons.people_rounded, 'Members', () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MemberListPage(
            isBudgetGroup: isBudget, groupId: groupId, isMember: isMember);
      }));
    }),
    // ...actionRow(context, Icons.wallet_sharp, "View group transaction history",
    //     () {
    //   // TODO: Navigate to the transaction history page
    // }),
    ...actionRow(context, FontAwesomeIcons.paperPlane, "Group Invitations", () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return GroupPendingInvitationPage(
            groupId: groupId,
            type: isBudget ? InvitationType.budget : InvitationType.savings);
      }));
    }),
    ...actionRow(context, FontAwesomeIcons.trophy, "Group Challenge", () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ChallengePage(
            budgetGroupId: isBudget ? groupId : null,
            savingGroupId: isBudget ? null : groupId
        );
      }));
    })
  ];
  // if host
  if (!isMember) {
    actions.addAll([
      ...actionRow(context, Icons.edit, "Edit group", () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          if (isBudget) {
            return BudgetUpdatePage(budgetId: groupId);
          } else {
            return GroupSavingUpdatePage(goalId: groupId);
          }
        }));
      }),
      ...actionRow(context, FontAwesomeIcons.trashCan, "Delete Group??", () {
        showCustomDeleteConfirmationDialog(context,
            "Are you sure you want to delete this group? You cannot undo once you confirm",
            () async {
          await handleMainPageApi(context, () async {
            if (isBudget) {
              return await Provider.of<BudgetService>(context, listen: false)
                  .deleteBudget(groupId);
            } else {
              return await Provider.of<GroupSavingService>(context,
                      listen: false)
                  .deleteGroupSaving(groupId);
            }
          }, () async {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPageLayout(
                      customPageIndex: isBudget ? PageLocation.budgetPage.index : PageLocation.savingPage.index),
                ),
                (_) => false);
          });
        });
      }),
    ]);
  }
  return actions;
}

void showGroupActionBottomSheet(
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
