import 'package:flutter/material.dart';

class RadioField extends StatefulWidget {
  final String label;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final String defaultOption;
  // final List<String> options;
  // final String selectedOption;

  const RadioField({
    required this.label,
    required this.options,
    required this.onSelected,
    // required this.selectedOption,
    super.key, required this.defaultOption,
  });

  @override
  State<RadioField> createState() => _RadioFieldState();
}

class _RadioFieldState extends State<RadioField> {
  late String _selectedOption;

  @override
  void initState() {
    _selectedOption = widget.defaultOption;
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
        ...widget.options.map((option) => RadioListTile<String>(
              title: Text(option, style: textTheme.bodyLarge, maxLines: 2,),
              value: option,
              groupValue: _selectedOption,
              onChanged: _onOptionSelected,
            )),
      ],
    );
  }
}
