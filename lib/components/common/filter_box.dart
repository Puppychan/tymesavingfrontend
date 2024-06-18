import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';

class FilterBox extends StatefulWidget {
  // final Map<String, dynamic> filterData;
  final List<String> filterData;
  final String label;
  final bool Function(int)? defaultConditionInit;
  final void Function(int) onToggle;

  const FilterBox(
      {super.key,
      required this.filterData,
      required this.label,
      this.defaultConditionInit, required this.onToggle});

  @override
  State<FilterBox> createState() => _FilterBoxState();
}

class _FilterBoxState extends State<FilterBox> {
  List<bool> _selections = []; // array of true/false values

  @override
  void initState() {
    super.initState();
    _updateSelections();
  }

  void _updateSelections() {
    final bool Function(int) safeConditionInit =
        widget.defaultConditionInit ?? (_) => false;
    setState(() {
      _selections = List.generate(
          widget.filterData.length, (index) => safeConditionInit(index));
    });
  }

  void _onToggle(int index) {
    setState(() {
      for (int buttonIndex = 0;
          buttonIndex < _selections.length;
          buttonIndex++) {
        if (buttonIndex == index) {
          _selections[buttonIndex] = true;
        } else {
          _selections[buttonIndex] = false;
        }
      }
      widget.onToggle(index);
      // final userService = Provider.of<UserService>(context, listen: false);
      // userService.updateFilterOptions('role', widget.filterData[index]);

      // widget.filterData['sortBy'] = ['Date', 'Popularity', 'Distance'][index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: textTheme.bodyLarge),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ToggleButtons(
            constraints: MediaQuery.of(context).size.width > 600
                ? BoxConstraints(
                    minWidth: (MediaQuery.of(context).size.width - 100) / 3,
                    minHeight: 50)
                : BoxConstraints(
                    minWidth: (MediaQuery.of(context).size.width - 50) / 3,
                    minHeight: 50),
            isSelected: _selections,
            onPressed: _onToggle,
            children: widget.filterData
                .map((data) => Padding(
                      padding: AppPaddingStyles.componentPadding,
                      child: Text(data),
                    ))
                .toList(),
            // children: widget.filterData.map((data) => Text(data)).toList(),
          ),
        )
      ],
    );
  }
}
