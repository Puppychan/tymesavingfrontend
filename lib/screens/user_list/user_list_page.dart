import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/components/user/user_card.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});
  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late List<User> users = [];
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      final userService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await userService.fetchUserList();
      }, () async {
        setState(() {
          users = userService.users;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return users.isNotEmpty
        ? Expanded(
            child: ListView.separated(
              itemCount: users.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                return UserCard(
                  user: users[index],
                  onEdit: () {
                    // Implement your edit functionality
                    print('Edit ${users[index].fullname}');
                  },
                  onDelete: () {
                    // Implement your delete functionality
                    print('Delete ${users[index].fullname}');
                  },
                );
              },
            ),
          )
        : const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
