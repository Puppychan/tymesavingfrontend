import 'package:flutter/material.dart';


class BuildInfo extends StatelessWidget {
  const BuildInfo(this.label, this.value,{super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            const SizedBox(width: 5,height: 10,),
            Text(label,),
            const SizedBox(width: 5,),
            Text(value,),
          ],
          )
        ),
    );
  }
}