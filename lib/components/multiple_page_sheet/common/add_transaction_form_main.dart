import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
import 'package:tymesavingfrontend/components/common/dialog/input_dialog.dart';
import 'package:tymesavingfrontend/components/common/rounded_icon.dart';
import 'package:tymesavingfrontend/components/multiple_page_sheet/common/category_icon.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class AddTransactionFormMain extends StatefulWidget {
  final FormStateType type;
  const AddTransactionFormMain({super.key, required this.type});
  @override
  State<AddTransactionFormMain> createState() => _AddTransactionFormMainState();
}

class _AddTransactionFormMainState extends State<AddTransactionFormMain> {
  int _selectedAmount = 50;
  DateTime _selectedDate = DateTime.now();
  String _title = 'Starbuck Cappuccino';
  String _description = 'Description here....';
  String _paidBy = 'Paid by Momo 01234566';
  String _savingOrBudget = 'For None';

  // @override
  // void initState() {
  //   super.initState();
  //   final formStateService =
  //       Provider.of<FormStateProvider>(context, listen: false);
  //   setState(() {
  //     _formFields = formStateService.getFormField(widget.type);
  //     _selectedCategory = formStateService.getCategory(widget.type);
  //   });
  // }
  void onTransactionCategorySelected(TransactionCategory category) {
    Future.microtask(() async {
      if (!mounted) return;
      final formStateService =
          Provider.of<FormStateProvider>(context, listen: false);
      formStateService.updateFormCategory(category, widget.type);
    });
  }

  void onUpdateInputValue(String key, String value) {
    Future.microtask(() async {
      if (!mounted) return;
      final formStateService =
          Provider.of<FormStateProvider>(context, listen: false);
      formStateService.updateFormField(key, value, widget.type);
    });
  }

  void onChangeAmount() {
    showInputDialog(
        context: context,
        label: "Total Amount",
        placeholder: "Your income amount",
        type: TextInputType.number,
        validator: Validator.validateAmount,
        successCall: (value) => {onUpdateInputValue("amount", value)});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

//
    return Consumer<FormStateProvider>(
        builder: (context, formStateService, child) {
      Map<String, dynamic> formFields =
          formStateService.getFormField(widget.type);
      TransactionCategory selectedCategory =
          formStateService.getCategory(widget.type);
      String formattedAmount = formStateService.getFormattedAmount(widget.type);

      List<Widget> renderCategories(BuildContext context) {
        return TransactionCategory.values.expand((category) {
          final isSelected = selectedCategory.name == category.name;
          Map<String, dynamic> categoryInfo =
              transactionCategoryData[category]!;
          return [
            Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  splashColor: colorScheme.tertiary,
                  onTap: () async => {onTransactionCategorySelected(category)},
                  child: getCategoryIcon(
                      currentCategoryInfo: categoryInfo,
                      isSelected: isSelected,
                      colorScheme: colorScheme),
                )),
            const SizedBox(width: 10)
          ];
        }).toList();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildComponentGroup(
              label: "CHOOSE CATEGORY",
              contentWidget: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: renderCategories(context),
                  ))),
          ..._buildComponentGroup(label: "TOTAL AMOUNT", contentWidget: [
            Row(
              children: [
                Text(formattedAmount, style: textTheme.displayMedium),
                GestureDetector(
                  onTap: onChangeAmount,
                  child: Text('Change', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [10, 50, 100, 500].map((amount) {
                return ChoiceChip(
                  label: Text('\$$amount'),
                  selected: _selectedAmount == amount,
                  onSelected: (selected) {
                    setState(() {
                      _selectedAmount = amount;
                    });
                  },
                );
              }).toList(),
            )
          ]),
          ..._buildComponentGroup(
              label: "DATE",
              contentWidget: _buildEditableRow(
                context: context,
                icon: Icons.calendar_today,
                title: 'DATE',
                value: 'Today',
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
              )),
          ..._buildComponentGroup(
              label: "DESCRIPTION",
              contentWidget: _buildEditableRow(
                context: context,
                icon: Icons.description,
                title: 'DESCRIPTION',
                value: _description,
                onTap: () => _showInputDialog(
                  context,
                  initialValue: _description,
                  onSubmitted: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                ),
              )),
          ..._buildComponentGroup(
              label: "PAID BY",
              contentWidget: _buildEditableRow(
                context: context,
                icon: Icons.payment,
                title: 'PAID BY',
                value: _paidBy,
                onTap: () => _showInputDialog(
                  context,
                  initialValue: _paidBy,
                  onSubmitted: (value) {
                    setState(() {
                      _paidBy = value;
                    });
                  },
                ),
              )),
          ..._buildComponentGroup(label: "DESCRIPTION", contentWidget: [
            Text('SAVING OR BUDGET', style: textTheme.subtitle1),
            SizedBox(height: 10),
            Column(
              children: ['For Saving', 'For Budget', 'For None'].map((option) {
                return RadioListTile(
                  title: Text(option),
                  value: option,
                  groupValue: _savingOrBudget,
                  onChanged: (value) {
                    setState(() {
                      _savingOrBudget = value!;
                    });
                  },
                );
              }).toList(),
            )
          ]),
        ],
      );
    });
  }

  List<Widget> _buildComponentGroup(
      {required dynamic contentWidget, required String label}) {
    final textTheme = Theme.of(context).textTheme;
    return [
      Text(label, style: textTheme.titleSmall),
      const SizedBox(height: 10),
      if (contentWidget is List) ...contentWidget else contentWidget,
      const SizedBox(height: 5),
      const Divider(),
      const SizedBox(height: 20),
    ];
  }

  Widget _buildEditableRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon),
              SizedBox(width: 10),
              Text(title, style: textTheme.subtitle1),
            ],
          ),
          Row(
            children: [
              Text(value, style: textTheme.bodyText2),
              SizedBox(width: 10),
              GestureDetector(
                onTap: onTap,
                child: Text('Change', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showInputDialog(
    BuildContext context, {
    required String initialValue,
    required ValueChanged<String> onSubmitted,
  }) async {
    TextEditingController controller =
        TextEditingController(text: initialValue);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Edit',
                      hintText: 'Enter new value',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onSubmitted(controller.text);
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
