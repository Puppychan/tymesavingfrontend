import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/constant/temp_constant.dart';
import 'package:tymesavingfrontend/common/enum/user_role_enum.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/components/common/dialog/delete_confirm_dialog.dart';
import 'package:tymesavingfrontend/components/common/images/circle_network_image.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/user_list/user_detail_page.dart';
import 'package:tymesavingfrontend/screens/user_profile/update_user_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserCard extends StatelessWidget {
  final User user;
  final double maxContribution = 100.0; // Example maximum contribution value

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthService>(context).user;

    void onEdit() {
      // Implement the edit functionality
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UpdateUserScreen(user: user)),
      );
    }

    Future showDeleteConfirmationDialog() async {
      showCustomDeleteConfirmationDialog(
          context, 'Are you sure you want to delete this user?', () async {
        final userService = Provider.of<UserService>(context, listen: false);
        await handleMainPageApi(context, () async {
          return await userService.deleteUser(user.username);
          // return result;
        }, () async {
          Navigator.of(context).pop();
        });
      });
    }

    // double progress = user.contribution / maxContribution; // Calculate the progress as a fraction
    String formattedDate =
        timeago.format(DateTime.parse(user.creationDate ?? ""));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: colorScheme.tertiary,
      shadowColor: colorScheme.shadow,
      elevation: 5,
      child: InkWell(
        splashColor: colorScheme.quaternary,
        onTap: () {
          // debugPrint('Challenge tapped.');
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UserDetailPage(user: user);
          }));
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                      user.role == UserRole.admin
                          ? Icons.admin_panel_settings
                          : Icons.person,
                      color: user.role == UserRole.admin
                          ? colorScheme.secondary
                          : colorScheme.primary),
                  const SizedBox(width: 4),
                  const Expanded(child: Divider()),
                  const SizedBox(width: 4),
                  Text(
                    user.role.toString(),
                    style: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CustomCircleImage(
                      radius: 25.0,
                      imagePath: user.avatar ?? TEMP_AVATAR_IMAGE),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.start, // vertically centered
                    children: [
                      Text(user.username, style: textTheme.bodySmall),
                      Text(
                        "${user.fullname} ${currentUser?.fullname == user.fullname ? '(You)' : ''}",
                        style: textTheme.bodyLarge!.copyWith(
                          color: colorScheme.onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        user.email,
                        style: textTheme.bodyMedium!.copyWith(
                          fontStyle: FontStyle.italic,
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Joined $formattedDate",
                    style: textTheme.bodyMedium!,
                    maxLines: 2,
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: colorScheme.secondary),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: colorScheme.secondary),
                      onPressed: () async {
                        await showDeleteConfirmationDialog();
                      },
                    ),
                  ])
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
