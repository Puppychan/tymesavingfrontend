import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/app_padding.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';
import 'package:tymesavingfrontend/components/heading.dart';
import 'package:tymesavingfrontend/components/text_align.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/pages/user_card.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});
  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late final List<UserModel> users;
  @override
  void initState() {
    super.initState();
    users = UserModel.getUsers(); // This fetches the user data once during initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: const Heading(title: 'Users'),
      body: Padding(
        padding: AppPaddingStyles.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomAlignText(
              text: 'Manage Users Here',
              style: AppTextStyles.subHeading,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                itemCount: users.length,
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                // padding: const EdgeInsets.symmetric(horizontal: 15),
                itemBuilder: (context, index) {
                  return UserCard(
                    user: users[index],
                    onEdit: () {
                      // Implement your edit functionality
                      print('Edit ${users[index].name}');
                    },
                    onDelete: () {
                      // Implement your delete functionality
                      print('Delete ${users[index].name}');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
