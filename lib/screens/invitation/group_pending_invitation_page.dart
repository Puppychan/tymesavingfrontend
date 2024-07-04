import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/invitation/group_invitation_card.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class GroupPendingInvitationPage extends StatefulWidget {
  final String groupId;
  const GroupPendingInvitationPage({super.key, required this.groupId});

  @override
  State<GroupPendingInvitationPage> createState() => _GroupPendingInvitationPageState();
}

class _GroupPendingInvitationPageState extends State<GroupPendingInvitationPage> {
  bool _isDataFetched = false;

  void _fetchInvitations() {
    Future.microtask(() async {
      if (!mounted) return;

      // Fetch invitations from the backend
      await handleMainPageApi(context, () async {
        final intivationService =
            Provider.of<InvitationService>(context, listen: false);
        return await intivationService.fetchInvitationsByGroupId(widget.groupId);
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const Heading(
        title: "Pending Invitations",
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
                    return GroupInvitationCard(invitation: invitation);
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.faceSadTear),
                        SizedBox(width: 8.0),
                        Icon(FontAwesomeIcons.heartCrack),
                        SizedBox(width: 8.0),
                        Icon(FontAwesomeIcons.faceSadCry),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "Oops... No invitations found.",
                      style: textTheme.titleMedium!.copyWith(
                        color: colorScheme.secondary,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                );
        },
      ),
    );
  }
}
