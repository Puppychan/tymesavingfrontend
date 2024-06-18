import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/user_profile/update_user_page.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class UserCard extends StatelessWidget {
  final User user;
  final double maxContribution = 500.0; // Example maximum contribution value

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
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
    // String formattedDate = timeago.format(DateTime.parse(user.date));
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.tertiary, // Hex color for the background
          boxShadow: [
            BoxShadow(
              color: colorScheme.secondary.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
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
                      user.fullname,
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
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Contribute ',
                      style: Theme.of(context).textTheme.bodyMedium!,
                      children: <TextSpan>[
                        TextSpan(
                          // text: '\$${user.contribution.toStringAsFixed(2)}',
                          text: "User Contribution",
                          style: AppTextStyles.paragraphBold(context),
                        ),
                      ],
                    ),
                  ),
                  Text('Joined 3 days'
                      // formattedDate,
                      // style: Theme.of(context).textTheme.bodySmall!,
                      ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  // value: progress.clamp(0.0, 1.0), // Ensuring the value is between 0 and 1
                  value: 0.4, // Ensuring the value is between 0 and 1
                  backgroundColor: colorScheme.quaternary,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  minHeight: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
