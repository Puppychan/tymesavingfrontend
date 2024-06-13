import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tymesavingfrontend/components/mywallet_page/transaction_item.dart';

class MyWalletTransaction extends StatefulWidget {
  const MyWalletTransaction({super.key});

  @override
  State<MyWalletTransaction> createState() => _MyWalletTransactionState();
}

class _MyWalletTransactionState extends State<MyWalletTransaction> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: const [
        /*
          Data để test, sẽ thay đổi khi merge!
        */
        TransactionItem(
            title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
        TransactionItem(
            title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
        TransactionItem(
            title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
        TransactionItem(
            title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
        TransactionItem(
            title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
        TransactionItem(
            title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
        TransactionItem(
            title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
        TransactionItem(
            title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
        TransactionItem(
            title: 'Domino Pizza', amount: '2000', date: '18 March 2024'),
      ],
    );
  }
}
