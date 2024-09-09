import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/invitation/widget_invitation_user_selected.dart';
import 'package:tymesavingfrontend/components/user/user_tile.dart';
import 'package:tymesavingfrontend/screens/invitation/group_pending_invitation_page.dart';
import 'package:tymesavingfrontend/screens/search_page.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class InvitationAddForm extends StatelessWidget {
  final InvitationType type;
  final String groupId;

  final TextEditingController descriptionController = TextEditingController();

  InvitationAddForm({super.key, required this.type, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Consumer<FormStateProvider>(
        builder: (context, formStateService, child) {
      final invitationForm =
          formStateService.getFormField(FormStateType.memberInvitation);
      final formUsers = invitationForm["users"];

      // functions
      void searchUsers(String value, Function(List<dynamic>) updateResults,
          CancelToken? cancelToken) async {
        final userService = Provider.of<UserService>(context, listen: false);
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
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(
                        title: "Search User",
                        sideDisplay: InvitationUserSelectedWidget(
                          formUsers: formUsers,
                        ),
                        searchLabel: "Search using username - email - name",
                        searchPlaceholder: "Search potential members here...",
                        searchCallback:
                            (value, updateResults, cancelToken) async =>
                                searchUsers(value, updateResults, cancelToken),
                        resultWidgetFunction: (result) => UserTile(
                            user: result,
                            onTap: () {
                              // userController.text = result.id;
                              final multipleFormPageService =
                                  Provider.of<FormStateProvider>(context,
                                      listen: false);
                              multipleFormPageService.addElementToListField(
                                  "users",
                                  result,
                                  FormStateType.memberInvitation);
                              Navigator.pop(context);
                              SuccessDisplay.showSuccessToast(
                                  "Add user to invitation form", context);
                            })),
                  ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Find to Invite Users",
                    style: textTheme.titleSmall!
                        .copyWith(fontWeight: FontWeight.w700)),
                Icon(FontAwesomeIcons.searchengin,
                    color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ),
          const Divider(),
          InvitationUserSelectedWidget(
            formUsers: formUsers,
          ),
          const Divider(),
          const SizedBox(height: 16),
          UnderlineTextField(
            controller: descriptionController,
            label: 'Description',
            icon: FontAwesomeIcons.comments,
            placeholder: "Any message for this invitation?",
            defaultValue: "Join us now!",
          ),
          const SizedBox(height: 16),
          PrimaryButton(
              title: "Send Invitation ➤",
              onPressed: () {
                if (formUsers == null || formUsers.isEmpty) {
                  ErrorDisplay.showErrorToast(
                      "Please select at least one user", context);
                  return;
                }
                Future.microtask(() async {
                  await handleMainPageApi(context, () async {
                    return await Provider.of<InvitationService>(context,
                            listen: false)
                        .sendInvitation(descriptionController.text, type,
                            groupId, formUsers);
                  }, () async {
                    formStateService.resetForm(FormStateType.memberInvitation);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupPendingInvitationPage(
                              groupId: groupId, type: type),
                        ),
                        (route) => false);
                    SuccessDisplay.showSuccessToast(
                        "Invitation sent successfully", context);
                  });
                });
              })
        ],
      );
    });
  }
}
