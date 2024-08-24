import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/transaction_group_type_enum.dart';
import 'package:tymesavingfrontend/models/base_group_model.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/group_saving_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class ShortGroupInfoMultiForm extends StatefulWidget {
  final TransactionGroupType chosenGroupType;
  final BaseGroup? chosenResult;
  final String? defaultGroupId;

  const ShortGroupInfoMultiForm(
      {super.key,
      this.chosenResult,
      required this.chosenGroupType,
      this.defaultGroupId});

  @override
  State<ShortGroupInfoMultiForm> createState() =>
      _ShortGroupInfoMultiFormState();
}

class _ShortGroupInfoMultiFormState extends State<ShortGroupInfoMultiForm> {
  BaseGroup? _displayGroup;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    // Unsubscribe from RouteObserver
    super.dispose();
  }

  void _fetchData() {
    if (widget.defaultGroupId != null) {
      Future.microtask(() async {
        await handleMainPageApi(context, () async {
          if (widget.chosenGroupType == TransactionGroupType.savings) {
            return await Provider.of<GroupSavingService>(context, listen: false)
                .fetchGroupSavingDetails(widget.defaultGroupId!);
          } else {
            return await Provider.of<BudgetService>(context, listen: false)
                .fetchBudgetDetails(widget.defaultGroupId!);
          }
        }, () async {
          setState(() {
            _displayGroup =
                widget.chosenGroupType == TransactionGroupType.savings
                    ? Provider.of<GroupSavingService>(context, listen: false)
                        .currentGroupSaving
                    : Provider.of<BudgetService>(context, listen: false)
                        .currentBudget;
          });
        });
      });
    } else {
      setState(() {
        _displayGroup = widget.chosenResult!;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (widget.chosenGroupType == TransactionGroupType.none) {
      return const SizedBox();
    }

    if (widget.chosenResult != null || widget.defaultGroupId != null) {
      return SizedBox(
          width: double.infinity,
          child: Card(
            shadowColor: colorScheme.onPrimary,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Icon(widget.chosenGroupType == TransactionGroupType.budget
                      ? Icons.savings
                      : Icons.assessment),
                  const SizedBox(height: 3),
                  Text(_displayGroup?.name ?? "",
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 3),
                  Text(
                    _displayGroup?.description ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ));
    }
    return const SizedBox();
  }
}
