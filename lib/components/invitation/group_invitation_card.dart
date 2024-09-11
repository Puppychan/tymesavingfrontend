import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/invitation_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/components/common/dialog/delete_confirm_dialog.dart';
import 'package:tymesavingfrontend/models/invitation_model.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class GroupInvitationCard extends StatefulWidget {
  final Invitation invitation;

  const GroupInvitationCard({super.key, required this.invitation});

  @override
  State<GroupInvitationCard> createState() => _GroupInvitationCardState();
}

class _GroupInvitationCardState extends State<GroupInvitationCard> {
  bool _isDataFetched = false;

  void _fetchData() async {
    if (!_isDataFetched && mounted) {
      if (mounted) {
        setState(() {
          _isDataFetched = true;
        });
      }
    }
  }

  void _removeInvitation() {
    if (widget.invitation.status != InvitationStatus.pending) return;
    if (widget.invitation.userId == null) return;
    showCustomDeleteConfirmationDialog(
        context, "Are you sure you want to remove this invitation?", () async {
      await handleMainPageApi(context, () async {
        return await Provider.of<InvitationService>(context, listen: false)
            .recalInvitation(
                widget.invitation.invitationId, widget.invitation.userId ?? "");
      }, () async {
        Navigator.of(context).pop();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSlidable = widget.invitation.status == InvitationStatus.pending;

    return isSlidable
        ? Slidable(
            key: ValueKey(widget.invitation.code),
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              dismissible: DismissiblePane(
                onDismissed: () {
                  // Perform the remove action
                  _removeInvitation();
                },
              ),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    // Perform the remove action
                    _removeInvitation();
                  },
                  // backgroundColor: isDark ? colorScheme.error : colorScheme.onError,
                  backgroundColor:
                      isDark ? colorScheme.error : colorScheme.onError,
                  foregroundColor:
                      isDark ? colorScheme.secondary : colorScheme.onPrimary,
                  icon: Icons.delete,
                  label: 'Remove',
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ],
            ),
            child: _buildCardContent(context),
          )
        : _buildCardContent(context);
  }

  Widget _buildCardContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.divider,
            width: 2, // Set the width of the bottom border
          ),
        ),
        // borderRadius: BorderRadius.circular(12),
      ),
      // elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Pending State Display, and code
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Avatar
                    Icon(
                      Icons.circle_rounded,
                      size: 18,
                      color:
                          widget.invitation.status == InvitationStatus.pending
                              ? colorScheme.inversePrimary
                              : colorScheme.error,
                    ),
                    const SizedBox(width: 10),
                    // Name
                    Text(
                      widget.invitation.status.toString(),
                      overflow: TextOverflow.fade,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
                // Timestamp
                // Text(
                //   widget.invitation.code,
                //   style: textTheme.bodySmall?.copyWith(
                //     color: Colors.grey,
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sent to ${widget.invitation.userFullName}",
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Content
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: Text(
                        "`${widget.invitation.description}`",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.7),
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Icon(
                  widget.invitation.type == InvitationType.budget
                      ? Icons.savings
                      : Icons.assessment,
                  size: 45.0,
                )
              ],
            )
            // Headline
          ],
        ),
      ),
    );
  }
}
