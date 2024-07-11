import 'package:flutter/material.dart';

List<Widget> actionRow(
    BuildContext context, IconData icon, String label, Function() onPressed) {
  return [
    TextButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(" $label", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.w600
      )),
      onPressed: () {
        Navigator.pop(context);
        onPressed();
      },
    ),
    const Divider(),
    const SizedBox(height: 15),
  ];
}
