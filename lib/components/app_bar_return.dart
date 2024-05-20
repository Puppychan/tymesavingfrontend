import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';

class AppBarReturn extends StatefulWidget {
  const AppBarReturn(this.title, this.function, {super.key});

  final String title;
  final VoidCallback function;

  @override
  State<AppBarReturn> createState() => _AppBarReturnState();
}

class _AppBarReturnState extends State<AppBarReturn> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title, style: AppTextStyles.boldHeadingBlue),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_outlined),
        onPressed: (){
          widget.function();
        },
      ),
    );
  }
}