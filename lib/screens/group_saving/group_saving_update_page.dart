import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/form/common_form/group_saving_form.dart';
import 'package:tymesavingfrontend/models/group_saving_model.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/group_saving_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class GroupSavingUpdatePage extends StatefulWidget {
  final String goalId;

  const GroupSavingUpdatePage({super.key, required this.goalId});

  @override
  State<GroupSavingUpdatePage> createState() => _GroupSavingUpdatePageState();
}

class _GroupSavingUpdatePageState extends State<GroupSavingUpdatePage> {
  GroupSaving? _goal;

  @override
  void initState() {
    Future.microtask(() async {
      if (!mounted) return;
      final goalService =
          Provider.of<GroupSavingService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await goalService.fetchGroupSavingDetails(widget.goalId);
      }, () async {
        if (!mounted) return;
        final tempGroupSaving = goalService.currentGroupSaving;
        // // set goal to update form
        final formStateService =
            Provider.of<FormStateProvider>(context, listen: false);
        formStateService.setUpdateGroupSavingFormFields(tempGroupSaving);
        setState(() {
          _goal = tempGroupSaving;
        });

        // // update state
        // setState(() {
        //   _goal = tempGroupSaving;
        // });
        // await _renderUser(tempGroupSaving!.userId);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return const Scaffold(
        appBar: Heading(
          title: "Update Group Saving",
          showBackButton: true,
        ),
        body: SingleChildScrollView(
            padding: AppPaddingStyles.pagePadding,
            child: Column(
              children: [
                // buildRow(textTheme, "Created By",
                //     _user?.fullname ?? "Loading Full Name..."),
                // const Divider(),
                // buildRow(textTheme, "Username",
                //     _user?.username ?? "Loading Username..."),
                // const SizedBox(height: 20),
                // buildRow(
                //     textTheme, "Type", _goal?.type ?? "Loading Type..."),
                // const Divider(),
                // const SizedBox(height: 10),
                // TextButton(
                //     style: ButtonStyle(
                //       side: MaterialStateProperty.all(
                //         BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 1.5),
                //       ),
                //       padding: MaterialStateProperty.all(
                //           const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                //     ),
                //     onPressed: () {
                //       showStyledBottomSheet(
                //           context: context,
                //           title: "Category Selection",
                //           contentWidget: CategorySelectionPage(
                //               type: FormStateType.updateGroupSaving,
                //               onNavigateToNext: () => Navigator.pop(context)));
                //     },
                //     child: Text(
                //       "Category Details",
                //       style: textTheme.titleSmall,
                //     )),
                Divider(),
                GroupSavingFormMain(
                    type: FormStateType.updateGroupSaving),
              ],
            )));
  }

  Widget buildRow(TextTheme textTheme, String label, String value) {
    return Row(
      children: [
        Expanded(
            child: Text(
          label,
          style: textTheme.bodyLarge,
        )),
        // const Spacer(),
        Text(value, style: textTheme.bodyMedium),
      ],
    );
  }
}
