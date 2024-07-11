import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common/not_found_message.dart';
import 'package:tymesavingfrontend/components/invitation/auth_user_invitation_card.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isDataFetched = false;
  User? _user;

  void _fetchInvitations() {
    Future.microtask(() async {
      if (!mounted) return;
      setState(
        () {
          _user = Provider.of<AuthService>(context, listen: false).user;
        },
      );

      // Fetch invitations from the backend
      await handleMainPageApi(context, () async {
        final intivationService =
            Provider.of<InvitationService>(context, listen: false);
        return await intivationService.fetchInvitations(_user?.id ?? "");
      }, () async {});
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchInvitations();
    setState(() {
      _isDataFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Heading(
        title: "Your Invitations",
        showBackButton: true,
      ),
      body: Consumer<InvitationService>(
        builder: (context, invitationService, child) {
          final invitations = invitationService.invitations;
          if (!_isDataFetched) return const Center(child: CircularProgressIndicator());
          return invitations.isNotEmpty
              ? ListView.builder(
                  padding: AppPaddingStyles.pagePadding,
                  itemCount: invitations.length,
                  itemBuilder: (context, index) {
                    final invitation = invitations[index];
                    return AuthUserInvitationCard(invitation: invitation);
                  },
                )
              : const NotFoundMessage(message: "Oops... No invitations found.",);
        },
      ),
    );
  }
}
