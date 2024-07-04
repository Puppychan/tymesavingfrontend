import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/invitation_status_enum.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/invitation/group_invitation_card.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class GroupPendingInvitationPage extends StatefulWidget {
  final String groupId;
  const GroupPendingInvitationPage({super.key, required this.groupId});

  @override
  State<GroupPendingInvitationPage> createState() =>
      _GroupPendingInvitationPageState();
}

class _GroupPendingInvitationPageState extends State<GroupPendingInvitationPage>
    with SingleTickerProviderStateMixin {
  bool _isDataFetched = false;
  late TabController _tabController;

  void _fetchInvitations() {
    Future.microtask(() async {
      if (!mounted) return;

      // Fetch invitations from the backend
      await handleMainPageApi(context, () async {
        final invitationService =
            Provider.of<InvitationService>(context, listen: false);
        if (_tabController.index == 0) {
          // Fetch pending invitations
          invitationService.setFilterOptions(
              "getStatus", InvitationStatus.pending.toString());
        } else if (_tabController.index == 1) {
          invitationService.setFilterOptions(
              "getStatus", InvitationStatus.cancelled.toString());
        }

        return await invitationService
            .fetchInvitationsByGroupId(widget.groupId);
      }, () async {});
    });
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    _fetchInvitations(); // Fetch invitations when tab changes
  }

  @override
  void initState() {
    super.initState();
      _tabController = TabController(length: 2, vsync: this);  
    _tabController.addListener(_handleTabSelection);
    _fetchInvitations();
    setState(() {
      _isDataFetched = true;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: Heading(
                title: "Invitations",
                showBackButton: true,
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Pending'),
                    Tab(text: 'Cancelled'),
                  ],
                )),
            body: TabBarView(children: [
              Consumer<InvitationService>(
                builder: (context, invitationService, child) {
                  final invitations = invitationService.invitations;
                  if (!_isDataFetched) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return invitations.isNotEmpty
                      ? ListView.builder(
                          padding: AppPaddingStyles.pagePadding,
                          itemCount: invitations.length,
                          itemBuilder: (context, index) {
                            final invitation = invitations[index];
                            return GroupInvitationCard(invitation: invitation);
                          },
                        )
                      : buildNoInvitation(textTheme, colorScheme);
                },
              ),
              Consumer<InvitationService>(
                builder: (context, invitationService, child) {
                  final invitations = invitationService.invitations;
                  if (!_isDataFetched) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return invitations.isNotEmpty
                      ? ListView.builder(
                          padding: AppPaddingStyles.pagePadding,
                          itemCount: invitations.length,
                          itemBuilder: (context, index) {
                            final invitation = invitations[index];
                            return GroupInvitationCard(invitation: invitation);
                          },
                        )
                      : buildNoInvitation(textTheme, colorScheme);
                },
              ),
            ])));
  }

  Widget buildNoInvitation(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
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
  }
}
