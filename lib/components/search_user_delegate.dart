import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class UserSearchDelegate extends SearchDelegate<String?> {
  Future<SummaryUser?> _searchUser(
      BuildContext context, String username) async {
    SummaryUser? user;
    await handleMainPageApi(context, () async {
      return await Provider.of<UserService>(context, listen: false)
          .searchUserByUsername(username);
    }, () async {
      user = Provider.of<UserService>(context, listen: false).summaryUser;
    });
    return user;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // No need to implement this for our use case
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<SummaryUser?>(
      future: _searchUser(context, query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.username.isEmpty) {
          return const Center(child: Text('No users found'));
        }
        final user = snapshot.data!;
        return ListView.builder(
          itemCount:
              1, // TODO: after backend convert to search username containing
          itemBuilder: (context, index) {
            // final user = users[index];
            return InkWell(
                onTap: () {
                  close(context, user.username);
                },
                child: Card(
                    child: Column(
                  children: [
                    Text(user.username, style: textTheme.bodyMedium),
                    Text(user.fullname, style: textTheme.titleSmall),
                    Text(user.email ?? "",
                        style: textTheme.bodyMedium!
                            .copyWith(fontStyle: FontStyle.italic)),
                  ],
                )));
          },
        );
      },
    );
  }
}
