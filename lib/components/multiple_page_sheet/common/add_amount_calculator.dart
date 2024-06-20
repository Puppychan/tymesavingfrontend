// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
// import 'package:tymesavingfrontend/common/enum/transaction_category_enum.dart';
// import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
// import 'package:tymesavingfrontend/components/common/dialog/input_dialog.dart';
// import 'package:tymesavingfrontend/components/common/round_text_field.dart';
// import 'package:tymesavingfrontend/components/multiple_page_sheet/common/category_icon.dart';
// import 'package:tymesavingfrontend/services/multi_page_form_service.dart';
// import 'package:tymesavingfrontend/utils/validator.dart';

// class AddAmountCalculator extends StatefulWidget {
//   final FormStateType type;
//   const AddAmountCalculator({super.key, required this.type});

//   @override
//   State<AddAmountCalculator> createState() => _AddAmountCalculatorState();
// }

// class _AddAmountCalculatorState extends State<AddAmountCalculator> {
//   final TextEditingController _amountOneController = TextEditingController();
//   final TextEditingController _amountTwoController = TextEditingController();
//   double _result = 0.0;

//   void _calculateTotal() {
//     final double amountOne = double.tryParse(_amountOneController.text) ?? 0.0;
//     final double amountTwo = double.tryParse(_amountTwoController.text) ?? 0.0;
//     setState(() {
//       _result = amountOne + amountTwo;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     final formStateService =
//         Provider.of<FormStateProvider>(context, listen: false);
//     final formField = formStateService.getFormField(widget.type);
//     final currentTransactionCategoryInfo =
//         transactionCategoryData[formStateService.getCategory(widget.type)]!;
//     // final TransactionCategory selectedCategory =
//     //     formStateService.categoryIncome;

    

//     return Column(
//       children: [
//         ListTile(
//           contentPadding: EdgeInsets.zero,
//           titleAlignment: ListTileTitleAlignment.threeLine,
//           leading: getCategoryIcon(currentCategoryInfo: currentTransactionCategoryInfo),
//           title: Text(formField['category'].name,
//               style: Theme.of(context).textTheme.bodyLarge),
//           // subtitle: const Text('Type your income name...'),
//           subtitle: Text(_subtitleText),
//           trailing: TextButton(
//               onPressed: () {
//                 // _showInputDialog(context);
//                 showInputDialog(context: context, label: "Income Title", placeholder: "Your Income Title...", validator: Validator.validateTitle);
//               },
//               child: Text('Change',
//                   style: textTheme.titleMedium
//                       ?.copyWith(color: colorScheme.primary))),
//         ),
//         const Divider(),
//         const SizedBox(height: 20),
//         Text('TOTAL AMOUNT', style: Theme.of(context).textTheme.bodyLarge),
//         const SizedBox(height: 10),
//         const Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Chip(label: Text('10')),
//             Chip(label: Text('50')),
//             Chip(
//                 label: Text('100', style: TextStyle(color: Colors.white)),
//                 backgroundColor: Colors.amber),
//             Chip(label: Text('500')),
//           ],
//         ),
//         const SizedBox(height: 20),
//         const TextField(
//           decoration: InputDecoration(
//             prefixText: '\$ ',
//             prefixStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             border: OutlineInputBorder(),
//             hintText: '100',
//             hintStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           keyboardType: TextInputType.number,
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 20),
//         GridView.builder(
//           shrinkWrap: true,
//           itemCount: 12,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             mainAxisSpacing: 10,
//             crossAxisSpacing: 10,
//             childAspectRatio: 2,
//           ),
//           itemBuilder: (context, index) {
//             if (index == 9) return const SizedBox.shrink();
//             if (index == 10) {
//               return TextButton(onPressed: () {}, child: const Text('0'));
//             }
//             if (index == 11) {
//               return TextButton(onPressed: () {}, child: const Text('Done'));
//             }
//             return TextButton(
//               onPressed: () {},
//               child: Text('${index + 1}'),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
