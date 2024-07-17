import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/filter_box.dart';
import 'package:tymesavingfrontend/components/common/sort_box.dart';
import 'package:tymesavingfrontend/services/user_service.dart';

class UserSortFilter extends StatefulWidget {
  final void Function() updateUserList;
  const UserSortFilter({super.key, required this.updateUserList});

  @override
  State<UserSortFilter> createState() => _UserSortFilterState();
}

class _UserSortFilterState extends State<UserSortFilter> {
  final List<String> filterRoleData = ["All", "Admin", "Customer"];
  // final List<String> options = ["Username", "Created Date", "Role"];
  // List<String> convertOptionsToText() {
  //   return options.expand((option) {
  //     return [
  //       '$option in ascending order',
  //       '$option in descending order',
  //     ];
  //   }).toList();
  // }'

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    debugPrint(
        "User Service Sort Options: ${userService.sortOption}"); // "Username in ascending order

    return Column(children: [
      FilterBox(
        filterData: filterRoleData,
        label: "User Role",
        defaultConditionInit: (index) =>
            userService.roleFilter == filterRoleData[index],
        onToggle: (index) {
          userService.updateFilterOptions('role', filterRoleData[index]);
          widget.updateUserList();
        },
      ),
      const SizedBox(height: 10),
      const Divider(),
      const SizedBox(height: 10),
      SortBox(
          label: "Sort Options",
          options: userService.combineOptions(),
          selectedField: userService.sortOption.keys.first,
          selectedOrder: userService.sortOption.values.first,
          onSelected: (value) {
            final tempSortValue = value.split(' ')[0];
            final order = value.split(' ')[2];
            userService.updateSortOptions(tempSortValue, order);
            widget.updateUserList();
          })
    ]);
  }
}
