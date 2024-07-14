import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/user/user_tile.dart';
import 'package:tymesavingfrontend/screens/search_page.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class InvitationAddWidget extends StatelessWidget {
  final InvitationType type;
  final String groupId;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController userController = TextEditingController();

  InvitationAddWidget({super.key, required this.type, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Consumer<FormStateProvider>(
            builder: (context, formStateService, child) {
          final invitationForm =
              formStateService.getFormField(FormStateType.memberInvitation);
          final formUsers = invitationForm["users"];
          // functions
          void searchUsers(String value, Function(List<dynamic>) updateResults,
              CancelToken? cancelToken) async {
            final userService =
                Provider.of<UserService>(context, listen: false);
            await handleMainPageApi(context, () async {
              return await userService.searchUsers(value,
                  type: type,
                  exceptGroupId: groupId,
                  exceptUsers: formUsers,
                  cancelToken: cancelToken);
            }, () async {
              updateResults(userService.searchUserList);
            }, notFoundAction: () async {
              updateResults([]);
            }, cancelAction: () async {
              updateResults([]);
            });
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height:
                    100, // Set a fixed height for the horizontal list container
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: formUsers?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100, // Set a fixed width for each item
                      child: Card(
                        child: Center(
                          child: Text(formUsers[index]
                              .username), // Display the username
                        ),
                      ),
                    );
                  },
                ),
              ),
              TextField(
                controller: userController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(
                                title: "Search User",
                                searchLabel:
                                    "Search using username - email - name",
                                searchPlaceholder:
                                    "Search potential members here...",
                                searchCallback:
                                    (value, updateResults, cancelToken) async =>
                                        searchUsers(
                                            value, updateResults, cancelToken),
                                resultWidgetFunction: (result) => UserTile(
                                    user: result,
                                    onTap: () {
                                      // userController.text = result.id;
                                      final multipleFormPageService =
                                          Provider.of<FormStateProvider>(
                                              context,
                                              listen: false);
                                      multipleFormPageService
                                          .addElementToListField(
                                              "users",
                                              result,
                                              FormStateType.memberInvitation);
                                      SuccessDisplay.showSuccessToast(
                                          "Add user to invition list", context);
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
          );
        }));
  }
}
