import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/sort_box.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';

class TransactionSortFilter extends StatefulWidget {
  final void Function() updateTransactionList;
  const TransactionSortFilter({super.key, required this.updateTransactionList});

  @override
  State<TransactionSortFilter> createState() => _TransactionSortFilterState();
}

class _TransactionSortFilterState extends State<TransactionSortFilter> {
  // final List<String> filterGroupType = ["All", "Admin", "Customer"];
  // final List<String> options = ["sortGroupId", "sortGroupType", "sortStatus"];
  @override
  Widget build(BuildContext context) {
    final transactionService =
        Provider.of<TransactionService>(context, listen: false);

    return Column(children: [
      // FilterBox(
      //   filterData: TransactionType.formattedList,
      //   label: "Group Type",
      //   defaultConditionInit: (index) => transactionService.filterOptions["getGroupType"] == TransactionType.values[index].toString(),
      //   onToggle: (index) {
      //     transactionService.setFilterOptions('getGroupType', TransactionType.fromIndex(index).toString());
      //     widget.updateTransactionList();
      //   },
      // ),
      const SizedBox(height: 10),
      const Divider(),
      const SizedBox(height: 10),
      ...transactionService.sortOptions.keys.map<Widget>((optionKey) {
        String newOptionField = transactionService.convertOptionToUI(optionKey);
        return SortBox(
            label: "Sort $newOptionField",
            options: [newOptionField],
            selectedField: newOptionField,
            selectedOrder: transactionService.sortOptions[optionKey] ?? "",
            onSelected: (sortField, order) {
              // update sort options
              transactionService.setOptions(
                  "sort", sortField, order.toLowerCase());
              widget.updateTransactionList();
            });
      }),
    ]);
  }
}
