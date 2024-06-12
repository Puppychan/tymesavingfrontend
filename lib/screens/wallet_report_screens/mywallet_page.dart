import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/components/common/chart/custom_line_chart.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/mywallet_page/mywallet_transaction.dart';

class MyWalletPage extends StatelessWidget {
  const MyWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Heading(
        title: 'Wallet',
        showBackButton: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 50,),
          CustomLineChart(
            jan: 1236,
            feb: 1222,
            mar: 4812,
            apr: 2241,
            may: 3118,
            jun: 2252,
            jul: 2255,
            aug: 4445,
            sep: 2261,
            oct: 8276,
            nov: 2222,
            dec: 1334,
          ),
          SizedBox(height: 20,),
          Text('Transaction',style: AppTextStyles.headingMedium,),
          Expanded(child: MyWalletTransaction(),),
          ]
      ),
      backgroundColor: AppColors.cream,
    );
  }
}
