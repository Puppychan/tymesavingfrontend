import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';

class SortBox extends StatefulWidget {
  final String label;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final String? selectedOption;

  const SortBox({
    required this.label,
    required this.options,
    required this.onSelected,
    this.selectedOption, 
    super.key,
  });

  @override
  State<SortBox> createState() => _SortBoxState();
}

class _SortBoxState extends State<SortBox> {
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption!;
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
        Text(widget.label, style: textTheme.headlineSmall),
        const SizedBox(height: 10),
        ...widget.options.map((option) => RadioListTile<String>(
              title: Text(option, style: textTheme.bodyMedium),
              value: option,
              groupValue: _selectedOption,
              onChanged: _onOptionSelected,
            )),
      ],
    );
  }
}
