import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    super.key, 
    required this.title, 
    required this.amount, 
    required this.date
  });

  final String title;
  final String amount;
  final String date;
  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: AppColors.primary.withOpacity(0.05 ),
      child: InkWell(
        splashColor: AppColors.black.withOpacity(0.1),
        onTap:  () async {
          /*
          Cái này sẽ dùng để route khi onTap đến pages riêng của transaction đó
          Có thể sẽ phải thêm param để biết được cái transaction đó là transaction nào!
          */
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
                Row(
                children: [
                  Column(children: [
                    Text(widget.title, style: Theme.of(context).textTheme.titleSmall!,),
                    Text(widget.date, style: Theme.of(context).textTheme.bodyMedium!,),
                  ],),
                  const Expanded(child: SizedBox()),
                  Text(widget.amount, style: Theme.of(context).textTheme.titleMedium!,),
                ],
              ),
            const Divider(color: AppColors.border,height: 2,)
            ]
          ),
        ),
      ),
    );
  }
}
