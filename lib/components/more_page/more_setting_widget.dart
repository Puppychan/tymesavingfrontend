import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/group_saving/group_saving_details.dart';
import 'package:tymesavingfrontend/screens/about_contact/about_us.dart';
import 'package:tymesavingfrontend/screens/authentication/sign_in_page.dart';
import 'package:tymesavingfrontend/screens/setting_page.dart';
import 'package:tymesavingfrontend/screens/tracking_report/spend_tracking.dart';
import 'package:tymesavingfrontend/screens/tracking_report/report_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';

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
  Future<void> placeHolderFunction() async {
    //Debug here
    debugPrint('function tapped!');
  }

  Future<void> sandBox() async {
    //Debug here
    if (!mounted) return;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const GroupSavingDetails(groupSavingId: '093383e3bb46e30bceaf76e8')));
  }

  Future<void> settingFunction() async {
    //Debug here
    if (!mounted) return;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SettingPage()));
  }

  Future<void> myWalletRoute() async {
    //Debug here
    if (!mounted) return;
    debugPrint('Tracking page tapped!');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SpendTracking()));
  }

  Future<void> myReport() async {
    //Debug here
    debugPrint('Report page tapped!');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ReportPage()));
  }

  Future<void> about() async {
    //Debug here
    debugPrint('About us tapped!');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AboutUs()));
  }

  Future<void> logoutFunction() async {
    //Debug here
    debugPrint('logout tapped!');
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInView(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card.outlined(
      color: colorScheme.surface,
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: Column(
          children: [
            /*
                Containing place holder function for development! Do change it in merge !
              */
            RowSettingTemplate('Spending tracking', 'Analytic of your expense & income',
                const Icon(Icons.wallet), myWalletRoute),
            RowSettingTemplate('My Report', 'Understand your cashflow',
                const Icon(Icons.help), myReport),
            RowSettingTemplate('Setting', 'Change setting and preference',
                const Icon(Icons.settings), settingFunction),
            RowSettingTemplate('Contact us', 'Send a email or direct hotline',
                const Icon(Icons.phone), sandBox),
            RowSettingTemplate('About', 'Some information about the project',
                const Icon(Icons.info), about),
            RowSettingTemplate('Logout', 'Logout your account here',
                const Icon(Icons.logout), logoutFunction),
          ],
        ),
      ),
    );
  }
}

class RowSettingTemplate extends StatefulWidget {
  const RowSettingTemplate(this.label, this.motto, this.icon, this.function,
      {super.key});

  final String label;
  final String motto;
  final Icon icon;
  final Future<void> Function() function;

  @override
  State<RowSettingTemplate> createState() => _RowSettingTemplateState();
}

class _RowSettingTemplateState extends State<RowSettingTemplate> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card.filled(
        color: colorScheme.surface,
        child: InkWell(
            splashColor: colorScheme.primary.withAlpha(50),
            onTap: () async {
              if (!mounted) return;
              await widget.function();
            },
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.label,
                          style: Theme.of(context).textTheme.titleLarge!,
                        ),
                        Text(
                          widget.motto,
                          style: Theme.of(context).textTheme.bodyMedium!,
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    Icon(widget.icon.icon),
                  ],
                ))));
  }
}
