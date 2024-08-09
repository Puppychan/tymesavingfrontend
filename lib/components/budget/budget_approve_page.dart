import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';

class BudgetApprovePage extends StatefulWidget {
  const BudgetApprovePage({super.key});

  @override
  State<BudgetApprovePage> createState() => _BudgetApprovePageState();
}

class _BudgetApprovePageState extends State<BudgetApprovePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Heading(title: "Approval page"),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}