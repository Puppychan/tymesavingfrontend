import 'package:flutter/material.dart';

List<Widget> buildComponentGroup(
    {required BuildContext context, required dynamic contentWidget, String? label}) {
  final textTheme = Theme.of(context).textTheme;
  return [
    if (label != null) Text(label, style: textTheme.titleSmall),
    label != null ? const SizedBox(height: 10) : const SizedBox.shrink(),
    if (contentWidget is List) ...contentWidget else contentWidget,
    const SizedBox(height: 5),
    const Divider(),
    const SizedBox(height: 30),
  ];
}
