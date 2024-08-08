import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/invitation_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common/not_found_message.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/invitation/group_invitation_card.dart';
import 'package:tymesavingfrontend/components/invitation/invitation_sort_filter.dart';
import 'package:tymesavingfrontend/form/invitation_add_form.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class GroupPendingInvitationPage extends StatefulWidget {
  final String groupId;
  final InvitationType type;
  const GroupPendingInvitationPage(
      {super.key, required this.groupId, required this.type});

  @override
  State<GroupPendingInvitationPage> createState() =>
      _GroupPendingInvitationPageState();
}

class _GroupPendingInvitationPageState extends State<GroupPendingInvitationPage>
    with SingleTickerProviderStateMixin, RouteAware {
  bool _isDataFetched = false;
  late TabController _tabController;
  Timer? _timer;

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

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchInvitations(); // Polling every 10 seconds
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _fetchInvitations();
    _startPolling();
    setState(() {
      _isDataFetched = true;
    });
  }

  @override
  void didChangeDependencies() {
    // Fetch invitations when the page is loaded
    super.didChangeDependencies();
    _fetchInvitations();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    // Fetch invitations when the page is navigated back to
    _fetchInvitations();
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
                    icon: const Icon(FontAwesomeIcons.userPlus),
                    onPressed: () {
                      showStyledBottomSheet(
                        context: context,
                        contentWidget: InvitationAddForm(
                            type: widget.type, groupId: widget.groupId),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.ellipsisVertical),
                    onPressed: () {
                      showStyledBottomSheet(
                        context: context,
                        initialChildSize: 0.7,
                        contentWidget: InvitationSortFilter(
                            isGroupPage: true,
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
    return const NotFoundMessage(
      message: "Oops... No invitations found.",
    );
  }
}
