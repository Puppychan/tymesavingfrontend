import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_color.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';

class Heading extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const Heading({super.key, required this.title, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: AppBar(
              backgroundColor: AppColors.cream,
              surfaceTintColor: AppColors.cream, // when scroll
              title: CustomAlignText(text: title, style: AppTextStyles.heading),
              leading: showBackButton
                  ? IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors
                            .primaryText, // Ensure AppColors.primaryText is defined
                        size: 24.0,
                        semanticLabel: 'Back to previous page',
                      ),
                    )
                  : null,
                  
            )));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 30);
}
