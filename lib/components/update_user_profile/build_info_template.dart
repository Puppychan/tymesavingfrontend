import 'package:flutter/material.dart';

class BuildInfo extends StatelessWidget {
  const BuildInfo(this.label, this.value, this.icon, {super.key});

  final String label;
  final String value;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card.filled(
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 10),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 5,
                      height: 10,
                    ),
                    Text(label, style: Theme.of(context).textTheme.titleSmall!),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium!,
                    ),
                  ],
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Icon(icon.icon, color: colorScheme.primary, size: 25),
              ],
            ),
            const Divider(
              thickness: 1,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
