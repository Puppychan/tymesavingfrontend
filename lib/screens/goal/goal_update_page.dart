import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/multiple_page_sheet/common/goal_form.dart';
import 'package:tymesavingfrontend/models/goal_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/goal_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class GoalUpdatePage extends StatefulWidget {
  final String goalId;

  const GoalUpdatePage({super.key, required this.goalId});

  @override
  State<GoalUpdatePage> createState() => _GoalUpdatePageState();
}

class _GoalUpdatePageState extends State<GoalUpdatePage> {
  Goal? _goal;

  @override
  void initState() {
    Future.microtask(() async {
      if (!mounted) return;
      final goalService =
          Provider.of<GoalService>(context, listen: false);
      await handleMainPageApi(context, () async {
        // TODO: add the fetchGoalDetails method to the goalService
        // return await goalService.fetchGoalDetails(widget.goalId);
      }, () async {
        if (!mounted) return;
        final tempGoal = goalService.currentGoal;
        // // set goal to update form
        final formStateService =
            Provider.of<FormStateProvider>(context, listen: false);
        formStateService.setUpdateGoalFormFields(tempGoal);
        setState(() {
          _goal = tempGoal;
        });

        // // update state
        // setState(() {
        //   _goal = tempGoal;
        // });
        // await _renderUser(tempGoal!.userId);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return const Scaffold(
        appBar: Heading(
          title: "Update Goal",
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
                //               type: FormStateType.updateGoal,
                //               onNavigateToNext: () => Navigator.pop(context)));
                //     },
                //     child: Text(
                //       "Category Details",
                //       style: textTheme.titleSmall,
                //     )),
                Divider(),
                GoalFormMain(
                    type: FormStateType.updateGoal),
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
