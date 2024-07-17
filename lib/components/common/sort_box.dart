import 'package:flutter/material.dart';

class SortBox extends StatefulWidget {
  final String label;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final String selectedField;
  final String selectedOrder;

  // final List<String> options;
  // final String selectedOption;

  const SortBox({
    required this.label,
    required this.options,
    required this.onSelected,
    // required this.selectedOption,
    super.key,
    required this.selectedField,
    required this.selectedOrder,
  });

  @override
  State<SortBox> createState() => _SortBoxState();
}

class _SortBoxState extends State<SortBox> {
  late String _selectedOption;
  late List<String> _convertedOptions;

  List<String> convertSortOptionToString(String option) {
    return [
      "$option in ascending order",
      "$option in descending order",
    ];
  }

  @override
  void initState() {
    _selectedOption =
        "${widget.selectedField} in ${widget.selectedOrder} order";
    _convertedOptions = widget.options.expand((optionField) {
      return convertSortOptionToString(optionField);
    }).toList();
    super.initState();
  }

  void _onOptionSelected(String? value) {
    if (value != null) {
      setState(() {
        _selectedOption = value;
        // widget.selectedField = tempSortValue;
        // widget.selectedOrder = order;
        widget.onSelected(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: textTheme.bodyLarge),
        const SizedBox(height: 10),
        ..._convertedOptions.map((option) => RadioListTile<String>(
              title: Text(option, style: textTheme.bodyLarge, maxLines: 2,),
              value: option,
              groupValue: _selectedOption,
              onChanged: _onOptionSelected,
            )),
      ],
    );
  }
}
