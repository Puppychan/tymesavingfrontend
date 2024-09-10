import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/components/common/dialog/delete_confirm_dialog.dart';
import 'package:tymesavingfrontend/models/member_model.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
import 'package:tymesavingfrontend/screens/user_list/member_detail_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:timeago/timeago.dart' as timeago;

class MemberCard extends StatelessWidget {
  final bool isCurrentUserHost;
  final bool isBudgetGroup;
  final String groupId;
  final Member member;
  final double maxContribution = 100.0;

  const MemberCard({
    super.key,
    required this.member,
    required this.groupId,
    required this.isBudgetGroup,
    required this.isCurrentUserHost,
  });

  void showDeleteConfirmationDialog(BuildContext context, SummaryUser user) {
    showCustomDeleteConfirmationDialog(
        context, "Are you sure you want to remove this member?", () async {
      final userService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await userService.removeGroupMember(
            isBudgetGroup, groupId, user.id);
        // return result;
      }, () async {
        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final SummaryUser user = member.user;
    final bool isHost = member.role == 'Host';
    // double progress = member.contribution / maxContribution; // Calculate the progress as a fraction
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    void removeWidget() {
      // Remove the widget
      showDeleteConfirmationDialog(context, user);
    }

    return (isCurrentUserHost && !isHost)
        ? Slidable(
            key: ValueKey(user.id),
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              dismissible: DismissiblePane(
                onDismissed: () {
                  removeWidget();
                },
              ),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    // Perform the remove action
                    removeWidget();
                  },
                  // backgroundColor: isDark ? colorScheme.error : colorScheme.onError,
                  backgroundColor:
                      isDark ? colorScheme.error : colorScheme.onError,
                  foregroundColor:
                      isDark ? colorScheme.secondary : colorScheme.onPrimary,
                  icon: Icons.delete,
                  label: 'Remove',
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ],
            ),
            child: _buildCard(context, user, isHost))
        : _buildCard(context, user, isHost);
  }

  Widget _buildCard(BuildContext context, SummaryUser user, bool isHost) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentUser = Provider.of<AuthService>(context).user;

    String formattedDate = timeago.format(DateTime.parse(member.joinedDate));

    return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: colorScheme.divider,
              width: 2, // Set the width of the bottom border
            ),
          ),
          // borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          splashColor: colorScheme.quaternary,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MemberDetailPage(
                user: user,
                groupId: groupId,
                isBudgetGroup: isBudgetGroup,
              );
            }));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // CustomCircleImage(imagePath: member.avatarPath),
                    Icon(
                        isHost
                            ? FontAwesomeIcons.crown
                            : FontAwesomeIcons.person,
                        size: 20.0,
                        color: Theme.of(context).colorScheme.inversePrimary),
                    const SizedBox(width: 8),
                    Text(
                      "${user.username} ${currentUser?.username == user.username ? '(You)' : ''}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
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
                                // text: '\$${member.contribution.toStringAsFixed(2)}',
                                text: user.fullname,
                                style: AppTextStyles.paragraphBold(context),
                              )
                            ],
                          ),
                        )),
                    const SizedBox(width: 3),
                    Text(
                      "Joined $formattedDate",
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
