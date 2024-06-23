import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/multiple_page_sheet/budget_add_form.dart';
import 'package:tymesavingfrontend/components/multiple_page_sheet/transaction_add_form.dart';

ListTile makeListTile({
  required IconData leadingIcon,
  required String title,
  required Function() onTap,
  required ColorScheme colorScheme,
  required TextTheme textTheme,
}) {
  const borderRadius = BorderRadius.horizontal(
      left: Radius.circular(10), right: Radius.circular(50));
  return ListTile(
    tileColor: colorScheme.tertiary,
    textColor: colorScheme.onTertiary,
    iconColor: colorScheme.primary,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
    shape: const RoundedRectangleBorder(borderRadius: borderRadius),
    leading: Icon(leadingIcon, size: 30),
    title: Text(title,
        style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500, fontFamily: 'Merriweather')),
    onTap: onTap,
  );
}

void showAddOptions(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;
  const defaultGap = SizedBox(height: 20);
  showStyledBottomSheet(
    initialChildSize: 0.6,
    isTransparentBackground: true,
    context: context,
    contentWidget: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        makeListTile(
          leadingIcon: Icons.account_balance_wallet,
          title: 'Add new budget plan',
          onTap: () {
            // Handle add new budget plan
            showBudgetFormA(context);
          },
          textTheme: textTheme,
          colorScheme: colorScheme,
        ),
        defaultGap,
        makeListTile(
          leadingIcon: Icons.attach_money,
          title: 'Add new income',
          onTap: () {
            // Handle add new budget plan
            Navigator.of(context).pop();
            showTransactionFormA(context, true);

            // showTransactionFirstSheet(context);
          },
          textTheme: textTheme,
          colorScheme: colorScheme,
        ),
        defaultGap,
        makeListTile(
          leadingIcon: Icons.money_off,
          title: 'Add new expense',
          onTap: () {
            // Handle add new budget plan
            Navigator.of(context).pop();
            showTransactionFormA(context, false);
          },
          textTheme: textTheme,
          colorScheme: colorScheme,
        ),
        defaultGap,
        makeListTile(
          leadingIcon: Icons.savings,
          title: 'Add new saving goal',
          onTap: () {
            // Handle add new budget plan
          },
          textTheme: textTheme,
          colorScheme: colorScheme,
        ),
        defaultGap,
        IconButton(
            // Close button
            iconSize: 33.0,
            color: colorScheme.onInverseSurface,
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.inversePrimary,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close))
      ],
    ),
  );
}
