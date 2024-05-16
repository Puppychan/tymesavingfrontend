import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/pages/user_card.dart';

class UserList extends StatelessWidget {
  UserList({super.key});

  late final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    users =
        UserModel.getUsers(); // This fetches the user data once during build
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Users",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.separated(
              itemCount: users.length,
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
    );
  }
}
