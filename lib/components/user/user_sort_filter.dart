import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/filter_box.dart';
import 'package:tymesavingfrontend/services/user_service.dart';

class UserSortFilter extends StatefulWidget {
  final void Function() updateUserList;
  const UserSortFilter({super.key, required this.updateUserList});

  @override
  State<UserSortFilter> createState() => _UserSortFilterState();
}

class _UserSortFilterState extends State<UserSortFilter> {
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    const List<String> filterRoleData = ["All", "Admin", "Customer"];
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
      )
    ]);
  }
}
