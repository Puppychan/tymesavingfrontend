import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/invitation_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/components/common/filter_box.dart';
import 'package:tymesavingfrontend/components/common/sort_box.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';

class InvitationSortFilter extends StatefulWidget {
  final void Function() updateInvitationList;
  const InvitationSortFilter({super.key, required this.updateInvitationList});

  @override
  State<InvitationSortFilter> createState() => _InvitationSortFilterState();
}

class _InvitationSortFilterState extends State<InvitationSortFilter> {
  // final List<String> filterGroupType = ["All", "Admin", "Customer"];
  // final List<String> options = ["sortGroupId", "sortGroupType", "sortStatus"];
  @override
  Widget build(BuildContext context) {
    final invitationService =
        Provider.of<InvitationService>(context, listen: false);

    return Column(children: [
      FilterBox(
        filterData: InvitationType.formattedList,
        label: "Group Type",
        defaultConditionInit: (index) => invitationService.filterOptions["getGroupType"] == InvitationType.values[index].toString(),
        onToggle: (index) {
          invitationService.setFilterOptions('getGroupType', InvitationType.fromIndex(index).toString());
          widget.updateInvitationList();
        },
      ),
      const SizedBox(height: 10),
      const Divider(),
      const SizedBox(height: 10),
      FilterBox(
        filterData: InvitationStatus.values.map((e) => e.toString()).toList(),
        label: "Invitation Status",
        defaultConditionInit: (index) => invitationService.filterOptions["getStatus"] == InvitationStatus.values[index].toString(),
        onToggle: (index) {
          invitationService.setFilterOptions('getGroupType', InvitationStatus.values[index].toString());
          widget.updateInvitationList();
        },
      ),
      const Divider(),
      const SizedBox(height: 10),
      ...invitationService.sortOptions.keys.map<Widget>((optionKey) {
        String newOptionField = invitationService.convertSortOptionToString(optionKey);
        return SortBox(
            label: "Sort Options",
            options: [newOptionField],
            selectedField: newOptionField,
            selectedOrder: invitationService.sortOptions[optionKey] ?? "",
            onSelected: (sortField, order) {
              invitationService.setSortOptions(
                  sortField, order.toLowerCase());
              widget.updateInvitationList();
            });
      }),
    ]);
  }
}
