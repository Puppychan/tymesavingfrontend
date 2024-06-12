import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';

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
        splashColor: AppColors.gray.withOpacity(0.1),
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
                    Text(widget.title, style: AppTextStyles.headingSmall,),
                    Text(widget.date, style: AppTextStyles.subHeadingSmall,),
                  ],),
                  const Expanded(child: SizedBox()),
                  Text(widget.amount, style: AppTextStyles.subHeadingMedium,),
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
