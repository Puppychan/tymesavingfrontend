import 'package:flutter/material.dart';

class SortBox extends StatefulWidget {
  final String label;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final String selectedOption;

  const SortBox({
    required this.label,
    required this.options,
    required this.onSelected,
    required this.selectedOption, 
    super.key,
  });

  @override
  State<SortBox> createState() => _SortBoxState();
}

class _SortBoxState extends State<SortBox> {
  late String _selectedOption;

  @override
  void initState() {
    _selectedOption = widget.selectedOption;
    super.initState();
  }

  void _onOptionSelected(String? value) {
    if (value != null) {
      setState(() {
        _selectedOption = value;
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
              title: Text(option, style: textTheme.bodyLarge),
              value: option,
              groupValue: _selectedOption,
              onChanged: _onOptionSelected,
            )),
      ],
    );
  }
}
