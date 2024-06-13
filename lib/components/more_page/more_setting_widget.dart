import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/screens/authentication/sign_in_page.dart';
import 'package:tymesavingfrontend/screens/wallet_report_screens/mywallet_page.dart';
import 'package:tymesavingfrontend/screens/wallet_report_screens/report_page.dart';
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

  Future<void> myWalletRoute() async {
    //Debug here
    if (!mounted) return;
    debugPrint('My Wallet tapped!');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyWalletPage()));

  }

  Future<void> myReport() async {
    //Debug here
    debugPrint('My Wallet tapped!');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ReportPage()));
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
      color: colorScheme.background,
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: Column(
          children: [
            /*
                Containing place holder function for development! Do change it in merge !
              */
            RowSettingTemplate('My Wallet', 'Access your wallet',
                const Icon(Icons.wallet), myWalletRoute),
            RowSettingTemplate('My Report', 'Understand your cashflow',
                const Icon(Icons.help), myReport),
            RowSettingTemplate('Setting', 'Change setting and preference',
                const Icon(Icons.settings), placeHolderFunction),
            RowSettingTemplate('Contact us', 'Send a email or direct hotline',
                const Icon(Icons.phone), placeHolderFunction),
            RowSettingTemplate('About', 'Change setting',
                const Icon(Icons.info), placeHolderFunction),
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
