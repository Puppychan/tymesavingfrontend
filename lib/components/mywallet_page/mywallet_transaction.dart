import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/components/mywallet_page/transaction_item.dart';

class MyWalletTransaction extends StatefulWidget {
  const MyWalletTransaction({super.key, required this.month, required this.expense});
  
  final String month;
  final int expense;
  
  @override
  State<MyWalletTransaction> createState() => _MyWalletTransactionState();
}

class _MyWalletTransactionState extends State<MyWalletTransaction> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cream,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Row(
            children: [
              const Icon(Icons.money_off,
                  color: AppColors.negative, size: 30),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: '${widget.month} expense is at ',
                      style: AppTextStyles.headingSmall, // Default style for the first part
                      children: <TextSpan>[
                        TextSpan(
                          text: '${widget.expense} ',
                          style: AppTextStyles.headingSmall.copyWith(color: AppColors.primaryBlue), // Same style for the expense value
                        ),
                        TextSpan(
                          text: 'vnd',
                          style: AppTextStyles.headingSmall.copyWith(color: AppColors.primaryBlue), // Different color for "vnd"
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
