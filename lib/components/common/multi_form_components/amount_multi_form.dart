import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/common/multi_form_components/comonent_multi_form.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/input_format_currency.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class AmountMultiForm extends StatelessWidget {
  final TextEditingController amountController;
  final Function updateOnChange;
  final bool isEditable;

  const AmountMultiForm(
      {super.key,
      required this.amountController,
      required this.updateOnChange,
      this.isEditable = true});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        UnderlineTextField(
            label: "TOTAL AMOUNT",
            controller: amountController,
            icon: Icons.attach_money,
            inputFormatters: [CurrencyInputFormatter()],
            placeholder: "Amount",
            keyboardType: TextInputType.number,
            readOnly: !isEditable,
            onChange: (value) {

              updateOnChange("amount");
            },
            validator: Validator.validateAmount),
        if (isEditable)
          ...buildComponentGroup(context: context, contentWidget: [
            // SizedBox(height: 10),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    50000.0,
                    100000.0,
                    500000.0,
                    1000000.0,
                    2000000.0,
                    5000000.0,
                    10000000.0,
                    15000000.0,
                    20000000.0,
                    50000000.0,
                    100000000.0
                  ].expand((amount) {
                    final selectedAmount =
                        convertFormattedAmountToNumber(amountController.text);
                    return [
                      ChoiceChip(
                        // color: MaterialStateProperty.all<Color>(
                        //     colorScheme.tertiary),
                        color: MaterialStateColor.resolveWith((states) =>
                            states.contains(MaterialState.selected)
                                ? colorScheme.primary
                                : colorScheme.tertiary),
                        label: Text(formatAmountToVnd(amount),
                            style: TextStyle(
                              color: selectedAmount == amount
                                  ? colorScheme.onPrimary
                                  : colorScheme
                                      .onTertiary, // Change colors as needed
                            )),
                        selected: selectedAmount == amount,
                        onSelected: (selected) {
                          amountController.text = formatAmountWithCommas(amount);
                          updateOnChange("amount");
                        },
                      ),
                      const SizedBox(width: 10)
                    ];
                  }).toList(),
                ))
          ]),
      ],
    );
  }
}
