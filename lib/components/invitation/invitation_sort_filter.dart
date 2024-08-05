import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/invitation_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/components/common/filter_box.dart';
import 'package:tymesavingfrontend/components/common/sort_box.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';

class InvitationSortFilter extends StatelessWidget {
  final void Function() updateInvitationList;
  final bool hasStatusTab;
  final bool isGroupPage; // if is called from group page
  const InvitationSortFilter(
      {super.key,
      required this.updateInvitationList,
      this.hasStatusTab = true,
      this.isGroupPage = false});

  @override
  Widget build(BuildContext context) {
    final invitationService =
        Provider.of<InvitationService>(context, listen: false);

    return Column(children: [
      if (isGroupPage == false)
        FilterBox(
          filterData: InvitationType.formattedList,
          label: "Group Type",
          defaultConditionInit: (index) =>
              invitationService.filterOptions["getGroupType"] ==
              InvitationType.values[index].toString(),
          onToggle: (index) {
            invitationService.setFilterOptions(
                'getGroupType', InvitationType.fromIndex(index).toString());
            updateInvitationList();
          },
        ),
      const SizedBox(height: 10),

      // show filter by status only if that page does not have status tab
      if (hasStatusTab == false) ...[
        const Divider(),
        const SizedBox(height: 10),
        FilterBox(
          filterData: InvitationStatus.values.map((e) => e.toString()).toList(),
          label: "Invitation Status",
          defaultConditionInit: (index) =>
              invitationService.filterOptions["getStatus"] ==
              InvitationStatus.values[index].toString(),
          onToggle: (index) {
            invitationService.setFilterOptions(
                'getGroupType', InvitationStatus.values[index].toString());
            updateInvitationList();
          },
        ),
      ],
      const Divider(),
      const SizedBox(height: 10),
      ...invitationService.sortOptions.keys.map<Widget>((optionKey) {
        if (isGroupPage == true && ["sortGroupId", "sortGroupType"].contains(optionKey)) {
          return const SizedBox.shrink();
        }
        String newOptionField =
            invitationService.convertSortOptionToString(optionKey);
        return SortBox(
            label: "Sort Options",
            options: [newOptionField],
            selectedField: newOptionField,
            selectedOrder: invitationService.sortOptions[optionKey] ?? "",
            onSelected: (sortField, order) {
              invitationService.setSortOptions(sortField, order.toLowerCase());
              updateInvitationList();
            });
      }),
    ]);
  }
}
