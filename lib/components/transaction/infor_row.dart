import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(value, textAlign: TextAlign.right, style: textTheme.bodyMedium,),
        ),
      ],
    );
  }
}
