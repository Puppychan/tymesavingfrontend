import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/multiple_page_sheet/common/budget_form.dart';
import 'package:tymesavingfrontend/components/category_list/category_selection.dart';
import 'package:tymesavingfrontend/models/budget_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class BudgetUpdatePage extends StatefulWidget {
  final String budgetId;

  const BudgetUpdatePage({super.key, required this.budgetId});

  @override
  State<BudgetUpdatePage> createState() => _BudgetUpdatePageState();
}

class _BudgetUpdatePageState extends State<BudgetUpdatePage> {
  Budget? _budget;

  @override
  void initState() {
    Future.microtask(() async {
      if (!mounted) return;
      final budgetService =
          Provider.of<BudgetService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await budgetService.fetchBudgetDetails(widget.budgetId);
      }, () async {
        if (!mounted) return;
        final tempBudget = budgetService.currentBudget;
        // // set budget to update form
        final formStateService =
            Provider.of<FormStateProvider>(context, listen: false);
        formStateService.setUpdateBudgetFormFields(tempBudget);
        setState(() {
          _budget = tempBudget;
        });

        // // update state
        // setState(() {
        //   _budget = tempBudget;
        // });
        // await _renderUser(tempBudget!.userId);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return const Scaffold(
        appBar: Heading(
          title: "Update Budget",
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
                //     textTheme, "Type", _budget?.type ?? "Loading Type..."),
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
                //               type: FormStateType.updateBudget,
                //               onNavigateToNext: () => Navigator.pop(context)));
                //     },
                //     child: Text(
                //       "Category Details",
                //       style: textTheme.titleSmall,
                //     )),
                Divider(),
                BudgetFormMain(
                    type: FormStateType.updateBudget),
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
