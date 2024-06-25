import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/components/user/user_card.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});
  @override
  State<UserListPage> createState() => _UserListPageState();
}

Widget buildFood(String foodName) => ListTile(
      title: Text(foodName),
      onTap: () {},
    );

class _UserListPageState extends State<UserListPage> {
  // late List<User> users = [];
  void _fetchUsers() async {
    Future.microtask(() async {
      if (!mounted) return;
      final userService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await userService.fetchUserList();
      }, () async {
        // setState(() {
        //   users = userService.users;
        // });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(builder: (context, userService, child) {
      final users = userService.users;
      return users.isNotEmpty
          ? Expanded(
              child: ListView.separated(
              itemCount: users.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                return UserCard(user: users[index]);
              },
            ))
          : const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
      // return ElevatedButton(
      //   onPressed: () => showStyledBottomSheet(
      //     context: context,
      //     title: "Filter",
      //     contentWidget: UserSortFilter(updateUserList: _fetchUsers),
      //   ),
      //   child: const Text('Show Filter'),
      // );
    });
  }
}
