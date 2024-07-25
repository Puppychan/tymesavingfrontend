import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/form/common_form/transaction_form.dart';
import 'package:tymesavingfrontend/components/category_list/category_selection.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class TransactionUpdatePage extends StatefulWidget {
  final String transactionId;

  const TransactionUpdatePage({super.key, required this.transactionId});

  @override
  State<TransactionUpdatePage> createState() => _TransactionUpdatePageState();
}

class _TransactionUpdatePageState extends State<TransactionUpdatePage> {
  Transaction? _transaction;
  User? _user;

  Future<void> _renderUser(userId) async {
    Future.microtask(() async {
      if (!mounted) return;
      final userService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await userService.getUserDataById(userId);
      }, () async {
        if (!mounted) return;
        setState(() {
          _user = userService.currentFetchUser;
        });
      });
    });
  }

  @override
  void initState() {
    Future.microtask(() async {
      if (!mounted) return;
      final transactionService =
          Provider.of<TransactionService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await transactionService.getTransaction(widget.transactionId);
      }, () async {
        if (!mounted) return;
        final tempTransaction = transactionService.getDetailedTransaction;
        // set transaction to update form
        final formStateService =
            Provider.of<FormStateProvider>(context, listen: false);
        formStateService.setUpdateTransactionFormFields(tempTransaction);

        // update state
        setState(() {
          _transaction = tempTransaction;
        });
        await _renderUser(tempTransaction!.userId);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: const Heading(
          title: "Update Transaction",
          showBackButton: true,
        ),
        body: SingleChildScrollView(
            padding: AppPaddingStyles.pagePadding,
            child: Column(
              children: [
                buildRow(textTheme, "Created By",
                    _user?.fullname ?? "Loading Full Name..."),
                const Divider(),
                buildRow(textTheme, "Username",
                    _user?.username ?? "Loading Username..."),
                const SizedBox(height: 20),
                buildRow(
                    textTheme, "Type", _transaction?.type ?? "Loading Type..."),
                const Divider(),
                const SizedBox(height: 10),
                TextButton(
                    style: ButtonStyle(
                      side: WidgetStateProperty.all(
                        BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 1.5),
                      ),
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                    ),
                    onPressed: () {
                      showStyledBottomSheet(
                          context: context,
                          title: "Category Selection",
                          contentWidget: CategorySelectionPage(
                              type: FormStateType.updateTransaction,
                              onNavigateToNext: () => Navigator.pop(context)));
                    },
                    child: Text(
                      "Category Details",
                      style: textTheme.titleSmall,
                    )),
                const Divider(),
                const TransactionFormMain(
                    type: FormStateType.updateTransaction),
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
