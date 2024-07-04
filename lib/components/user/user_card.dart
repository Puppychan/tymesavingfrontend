import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Confirmation'),
            content: const Text('Are you sure you want to delete this user?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Future.microtask(() async {
                    final userService =
                        Provider.of<UserService>(context, listen: false);
                    await handleMainPageApi(context, () async {
                      return await userService.deleteUser(user.username);
                      // return result;
                    }, () async {
                      Navigator.of(context).pop();
                    });
                  });
                  // onDelete();
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }

    // double progress = user.contribution / maxContribution; // Calculate the progress as a fraction
    String formattedDate = timeago.format(DateTime.parse(user.creationDate ?? ""));
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.tertiary,
      shadowColor: colorScheme.secondary.withOpacity(0.5),
      elevation: 5,
      child: InkWell(
        splashColor: colorScheme.quaternary,
        onTap: () {
          // debugPrint('Challenge tapped.');
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UserDetail(user: user);
          }));
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  // CustomCircleAvatar(imagePath: user.avatarPath),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "${user.username} ${currentUser?.username == user.username ? '(You)' : ''}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Expanded(
                  //     flex: 6,
                  //     child: Text.rich(
                  //       maxLines: 2,
                  //       overflow: TextOverflow.ellipsis,
                  //       TextSpan(
                  //         children: isHaveContribution
                  //             ? <TextSpan>[
                  //                 TextSpan(
                  //                   text: 'Contribute ',
                  //                   style:
                  //                       Theme.of(context).textTheme.bodyMedium!,
                  //                 ),
                  //                 TextSpan(
                  //                   // text: '\$${user.contribution.toStringAsFixed(2)}',
                  //                   text: "User Contribution",
                  //                   style: AppTextStyles.paragraphBold(context),
                  //                 ),
                  //               ]
                  //             : <TextSpan>[
                  //                 TextSpan(
                  //                   // text: '\$${user.contribution.toStringAsFixed(2)}',
                  //                   text: user.fullname,
                  //                   style: AppTextStyles.paragraphBold(context),
                  //                 )
                  //               ],
                  //       ),
                  //     )),
                  const SizedBox(width: 3),
                  Text(
                    "Joined $formattedDate",
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
