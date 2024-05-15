import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';

class MoreMenuSetting extends StatefulWidget {
  const MoreMenuSetting({super.key});

  @override
  State<MoreMenuSetting> createState() => _MoreMenuSettingState();
}

class _MoreMenuSettingState extends State<MoreMenuSetting> {

  /*
  PlaceHolder function, when merge replace it with function to redirect to 
  other screen (Settings, Wallet?, Help Center, Feedback, Contact us, About)
  */
  void placeHolderFunction(){
    //Debug here
   debugPrint('function tapped!');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card.outlined(
        color: AppColors.cream,
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          child: Column(
            children: [
              /*
                Containing place holder function for development! Do change it in merge !
              */
              RowSettingTemplate('My Wallet', 'Access your wallet', const Icon(Icons.wallet),placeHolderFunction),
              RowSettingTemplate('Setting', 'Change setting and preference', const Icon(Icons.settings),placeHolderFunction),
              RowSettingTemplate('Help Center', 'Change setting', const Icon(Icons.help),placeHolderFunction),
              RowSettingTemplate('Feedback', 'Voice your idea, opinion matter', const Icon(Icons.feedback_outlined),placeHolderFunction),
              RowSettingTemplate('Contact us', 'Send a email or direct hotline', const Icon(Icons.phone),placeHolderFunction),
              RowSettingTemplate('About', 'Change setting', const Icon(Icons.info),placeHolderFunction),
            ],
          ),
        ),
      ),
    );
  }
}

class RowSettingTemplate extends StatefulWidget {
  const RowSettingTemplate(this.label, this.motto, this.icon, this.function, {super.key});

  final String label;
  final String motto;
  final Icon icon;
  final VoidCallback function;

  @override
  State<RowSettingTemplate> createState() => _RowSettingTemplateState();
}

class _RowSettingTemplateState extends State<RowSettingTemplate> {
  @override
  Widget build(BuildContext context) {
    return Card.filled(
    color: AppColors.cream,
    child: InkWell(
          splashColor: Colors.blue.withAlpha(50),
          onTap: () {
            widget.function;
          },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: AppTextStyles.subHeadingMedium,),
              Text(widget.motto, style: AppTextStyles.headingSmall,),
           ],
          ),
          const Expanded(child: SizedBox()),
          Icon(widget.icon.icon),
        ],
       )
      )
    )
    );
  }
}