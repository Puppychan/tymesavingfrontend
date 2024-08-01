// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tymesavingfrontend/components/common/filter_box.dart';
// import 'package:tymesavingfrontend/components/common/sort_box.dart';
// import 'package:tymesavingfrontend/services/budget_service.dart';
// import 'package:tymesavingfrontend/services/group_saving_service.dart';

// class GroupSortFilter extends StatefulWidget {
//   final bool isBudget;
//   final void Function() updateGroupList;
//   const GroupSortFilter({super.key, required this.updateGroupList, required this.isBudget});

//   @override
//   State<GroupSortFilter> createState() => _GroupSortFilterState();
// }

// class _GroupSortFilterState extends State<GroupSortFilter> {
//   // final List<String> filterGroupType = ["All", "Admin", "Customer"];
//   // final List<String> options = ["sortGroupId", "sortGroupType", "sortStatus"];
//   @override
//   Widget build(BuildContext context) {
//     final groupService = widget.isBudget
//         ? Provider.of<BudgetService>(context, listen: false)
//         : Provider.of<GroupSavingService>(context, listen: false);
        

//     return Column(children: [
//       FilterBox(
//         filterData: GroupType.formattedList,
//         label: "Group Type",
//         defaultConditionInit: (index) => groupService.filterOptions["getGroupType"] == GroupType.values[index].toString(),
//         onToggle: (index) {
//           groupService.setFilterOptions('getGroupType', GroupType.fromIndex(index).toString());
//           widget.updateGroupList();
//         },
//       ),
//       const SizedBox(height: 10),
//       const Divider(),
//       const SizedBox(height: 10),
//       FilterBox(
//         filterData: GroupStatus.values.map((e) => e.toString()).toList(),
//         label: "Group Status",
//         defaultConditionInit: (index) => groupService.filterOptions["getStatus"] == GroupStatus.values[index].toString(),
//         onToggle: (index) {
//           groupService.setFilterOptions('getGroupType', GroupStatus.values[index].toString());
//           widget.updateGroupList();
//         },
//       ),
//       const Divider(),
//       const SizedBox(height: 10),
//       ...groupService.sortOptions.keys.map<Widget>((optionKey) {
//         String newOptionField = groupService.convertSortOptionToString(optionKey);
//         return SortBox(
//             label: "Sort Options",
//             options: [newOptionField],
//             selectedField: newOptionField,
//             selectedOrder: groupService.sortOptions[optionKey] ?? "",
//             onSelected: (sortField, order) {
//               groupService.setSortOptions(
//                   sortField, order.toLowerCase());
//               widget.updateGroupList();
//             });
//       }),
//     ]);
//   }
// }
