import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';
import 'package:tymesavingfrontend/components/report_page/transaction_item.dart';

class ReportTransaction extends StatefulWidget {
  const ReportTransaction({super.key});

  @override
  State<ReportTransaction> createState() => _ReportTransactionState();
}

class _ReportTransactionState extends State<ReportTransaction> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Transaction',style: AppTextStyles.headingMedium,),
          SizedBox(
            height: 270,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                  /*
                  Data để test, sẽ thay đổi khi merge!
                  */
                TransactionItem(title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
                TransactionItem(title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
                TransactionItem(title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
                TransactionItem(title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
                TransactionItem(title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
                ],
              ),
          ),
        ],),
    );
  }
}
