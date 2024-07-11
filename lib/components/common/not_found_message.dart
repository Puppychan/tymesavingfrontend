import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotFoundMessage extends StatelessWidget {
  final String message;

  const NotFoundMessage({super.key, this.message = 'No data found'});

  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.faceSadTear),
            SizedBox(width: 8.0),
            Icon(FontAwesomeIcons.heartCrack),
            SizedBox(width: 8.0),
            Icon(FontAwesomeIcons.faceSadCry),
          ],
        ),
        const SizedBox(height: 16.0),
        Text(
          message,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
