import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/user/user_tile.dart';
import 'package:tymesavingfrontend/screens/search_page.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

void showUserInputModal(BuildContext context) {
  final TextEditingController userController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  showStyledBottomSheet(
    context: context,
    contentWidget: Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: userController,
            decoration: InputDecoration(
              labelText: 'Username',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  void searchUsers(String value,
                      Function(List<dynamic>) updateResults) async {
                    final userService =
                        Provider.of<UserService>(context, listen: false);
                    await handleMainPageApi(context, () async {
                      return await userService.searchUsers(value);
                    }, () async {
                      updateResults(userService.searchUserList);
                    }, notFoundAction: () async {
                      updateResults([]);
                    });
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(
                            title: "Search User",
                            searchLabel: "Search using username - email - name",
                            searchPlaceholder:
                                "Search potential members here...",
                            searchCallback: (value, updateResults) async => searchUsers(value, updateResults),
                            resultWidgetFunction: (result) => UserTile(
                                user: result,
                                onTap: () {
                                  userController.text = result.id;
                                  Navigator.pop(context);
                                })),
                      ));
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          UnderlineTextField(
            controller: descriptionController,
            label: 'Description',
            placeholder: "Any message for this invitation?",
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle form submission
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      )),
    ),
  );
}
