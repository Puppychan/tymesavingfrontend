import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/screens/about_contact/about_us.dart';
import 'package:tymesavingfrontend/screens/authentication/sign_in_page.dart';
import 'package:tymesavingfrontend/screens/setting_page.dart';
import 'package:tymesavingfrontend/screens/tracking_report/spend_tracking.dart';
import 'package:tymesavingfrontend/screens/tracking_report/report_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MoreMenuSetting extends StatefulWidget {
  const MoreMenuSetting({super.key});

  @override
  State<MoreMenuSetting> createState() => _MoreMenuSettingState();
}

class _MoreMenuSettingState extends State<MoreMenuSetting> {

  Future<void> sandBox() async {
    if (!mounted) return;
  }

  Future<void> settingFunction() async {
    if (!mounted) return;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SettingPage()));
  }

  Future<void> myWalletRoute() async {
    if (!mounted) return;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SpendTracking()));
  }

  Future<void> myReport() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ReportPage()));
  }

  Future<void> about() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AboutUs()));
  }

  Future<void> logoutFunction() async {
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

  Future<void> _launchContact() async {
    final Uri phone = Uri(
      scheme: 'https',
      path: "//www.rmit.edu.vn/students/support"
    );
    if (await canLaunchUrl(phone)){
      await launchUrl(phone,
      mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Launch Phone failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card.outlined(
      color: colorScheme.background,
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: Column(
          children: [
            /*
                Containing place holder function for development! Do change it in merge !
              */
            RowSettingTemplate(
                'Cashflow tracking',
                'Analytic of your expense & income',
                const Icon(Icons.wallet),
                myWalletRoute),
            RowSettingTemplate('Monthly report', 'Your monthly report into your transaction',
                const Icon(Icons.report), myReport),
            RowSettingTemplate('Setting', 'Change setting and preference',
                const Icon(Icons.settings), settingFunction),
            RowSettingTemplate('Contact us', 'Student support',
                const Icon(Icons.help), _launchContact),
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
        color: colorScheme.background,
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 11.5),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    Icon(widget.icon.icon),
                  ],
                ))));
  }
}
