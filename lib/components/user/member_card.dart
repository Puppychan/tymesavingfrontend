import 'package:flutter/material.dart';
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

  const   MemberCard({
    super.key,
    required this.member,
    required this.groupId,
    required this.isBudgetGroup,
    required this.isCurrentUserHost,
  });

  @override
  Widget build(BuildContext context) {
    final SummaryUser user = member.user;
    final currentUser = Provider.of<AuthService>(context).user;
    final bool isHost = member.role == 'Host';

    Future showDeleteConfirmationDialog() async {
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

    // double progress = member.contribution / maxContribution; // Calculate the progress as a fraction
    String formattedDate = timeago.format(DateTime.parse(member.joinedDate));
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
        color: colorScheme.tertiary,
        shadowColor: colorScheme.shadow,
        elevation: 5,
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
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // CustomCircleImage(imagePath: member.avatarPath),
                        Icon(
                            isHost
                                ? FontAwesomeIcons.crown
                                : FontAwesomeIcons.person,
                            size: 20.0,
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
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
                    (isCurrentUserHost && !isHost)
                        ? IconButton(
                            icon: Icon(Icons.group_remove_rounded,
                                color: colorScheme.secondary),
                            onPressed: () async {
                              await showDeleteConfirmationDialog();
                            },
                          )
                        : Container(),
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
