import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/invitation_status_enum.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common/not_found_message.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/invitation/auth_user_invitation_card.dart';
import 'package:tymesavingfrontend/components/invitation/invitation_sort_filter.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isDataFetched = false;
  User? _user;

  void _fetchInvitations() {
    Future.microtask(() async {
      if (!mounted) return;
      if (_user == null) {
        setState(
          () {
            _user = Provider.of<AuthService>(context, listen: false).user;
          },
        );
      }

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
        return await invitationService.fetchInvitations(_user?.id ?? "");
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
                actions: [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.ellipsisVertical),
                    onPressed: () {
                      showStyledBottomSheet(
                        context: context,
                        contentWidget: InvitationSortFilter(
                            updateInvitationList: _fetchInvitations),
                      );
                    },
                  )
                ],
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
                            return AuthUserInvitationCard(
                                invitation: invitation);
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
                            return AuthUserInvitationCard(
                                invitation: invitation);
                          },
                        )
                      : buildNoInvitation(textTheme, colorScheme);
                },
              ),
            ])));
  }

  Widget buildNoInvitation(TextTheme textTheme, ColorScheme colorScheme) {
    return const NotFoundMessage(
      message:
          "You have no invitations yet. Plan your budget and invite your friends to join.",
    );
  }
}
