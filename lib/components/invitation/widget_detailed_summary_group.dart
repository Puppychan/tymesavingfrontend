import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tymesavingfrontend/models/summary_group_model.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget detailedSummaryGroup(BuildContext context, SummaryGroup? group) {
  final textTheme = Theme.of(context).textTheme;
  if (group == null) return const Center(child: CircularProgressIndicator());
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(FontAwesomeIcons.house, size: 18),
              ),
              TextSpan(
                  text: "  ${group.hostUsername}",
                  style: textTheme.bodyLarge),
            ],
          ),
        ),
        const SizedBox(height: 4.0),
        const Divider(),
        const SizedBox(height: 4.0),
        Text(group.name, style: textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold), maxLines: null,),
        const SizedBox(height: 4.0),
        Text(group.description, style: textTheme.bodyMedium, maxLines: null,),
        const SizedBox(height: 4.0),
        const Divider(),
        const SizedBox(height: 4.0),
        Text("Members: ${group.memberCount}", style: textTheme.bodyMedium),
        const SizedBox(height: 4.0),
        Text("Created: ${timeago.format(DateTime.parse(group.createdDate))}",
            style: textTheme.bodyMedium),
      ]);
}