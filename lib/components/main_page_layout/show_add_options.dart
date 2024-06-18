import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/bottom_sheet.dart';

void showAddOptions(BuildContext context) {
  showStyledBottomSheet(
    context: context,
    title: "Add options",
    contentWidget: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.account_balance_wallet),
          title: Text('Add new budget plan'),
          onTap: () {
            // Handle add new budget plan
          },
        ),
        ListTile(
          leading: Icon(Icons.attach_money),
          title: Text('Add new income'),
          onTap: () {
            // Handle add new income
          },
        ),
        ListTile(
          leading: Icon(Icons.money_off),
          title: Text('Add new expense'),
          onTap: () {
            // Handle add new expense
          },
        ),
        ListTile(
          leading: Icon(Icons.savings),
          title: Text('Add new saving goal'),
          onTap: () {
            // Handle add new saving goal
          },
        ),
      ],
    ),
  );
  // showModalBottomSheet(
  //   context: context,
  //   isScrollControlled: true,
  //   backgroundColor: Colors.transparent,
  //   builder: (BuildContext modalContext) {
  //     return DraggableScrollableSheet(
  //       initialChildSize: 0.4,
  //       minChildSize: 0.1,
  //       maxChildSize: 1,
  //       builder: (_, controller) => Container(
  //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //         decoration: BoxDecoration(
  //           color: Theme.of(context).colorScheme.background,
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
  //         ),
  //         child: ,
  //       ),
  //     );
  //   },
  // );
}
