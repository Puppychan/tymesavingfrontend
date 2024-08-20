import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/constant/temp_constant.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/components/common/dialog/delete_confirm_dialog.dart';
import 'package:tymesavingfrontend/components/common/images/rounded_network_image.dart';
import 'package:tymesavingfrontend/components/common/rounded_icon.dart';
import 'package:tymesavingfrontend/models/base_user_model.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';

class InvitationUserSelectedWidget extends StatelessWidget {
  final List<dynamic>? formUsers;

  const InvitationUserSelectedWidget({super.key, this.formUsers});

  @override
  Widget build(BuildContext context) {
    return (formUsers ?? []).isNotEmpty
        ? Padding(
          padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
            height: 120,
            child: ListView.builder(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: formUsers?.length ?? 0,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    showCustomDeleteConfirmationDialog(context,
                        "Are you sure to remove selected user to invitation form",
                        () {
                      final formStateService = Provider.of<FormStateProvider>(
                          context,
                          listen: false);
                      formStateService.removeElementFromListField("users",
                          formUsers?[index], FormStateType.memberInvitation);
                      // special case not using Future
                      Navigator.pop(context);
                      return Future<void>.value();
                    });
                  },
                  child: _buildUserTile(context, formUsers?[index]),
                );
              },
            )))
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
                child: Text(
              "No user selected",
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              textAlign: TextAlign.center,
            )));
  }

  Widget _buildUserTile(BuildContext context, UserBase? user) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
            width: 100,
            child: Column(
              children: [
                CustomRoundedImage(
                    imagePath: user?.avatar ?? TEMP_AVATAR_IMAGE, size: 60),
                const SizedBox(height: 8),
                Text(user?.username ?? "Loading...",
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center),
              ],
            )),
        Positioned(
            top: -10,
            right: 0,
            child: RoundedIcon(
              iconData: Icons.person_remove,
              iconColor: colorScheme.inversePrimary,
              backgroundColor: colorScheme.onInverseSurface,
              size: 33,
            )),
      ],
    );
  }
}
