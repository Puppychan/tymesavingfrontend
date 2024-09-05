import 'package:flutter/material.dart';

List<Widget> actionRow(
    BuildContext context, IconData icon, String label, Function() onPressed) {
  return [
    SizedBox(
      width: MediaQuery.of(context).size.width, // Takes full width of the screen
      child: TextButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(
          " $label",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
          onPressed();
        },
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft, // Align the content to the left
          padding: EdgeInsets.symmetric(horizontal: 16.0), // Optional padding
        ),
      ),
    ),
    const Divider(),
    const SizedBox(height: 15),
  ];
}
