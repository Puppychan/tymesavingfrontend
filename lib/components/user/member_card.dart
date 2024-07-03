// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
// import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
// import 'package:tymesavingfrontend/models/member_model.dart';
// import 'package:tymesavingfrontend/models/user_model.dart';
// import 'package:tymesavingfrontend/services/auth_service.dart';
// import 'package:tymesavingfrontend/utils/handling_error.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class MemberCard extends StatelessWidget {
//   final Member member;
//   final double maxContribution = 100.0; // Example maximum contribution value

//   const MemberCard({
//     super.key,
//     required this.member,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final User user = member.user;
//     // TODO: Implement member's contribution inside shared budget  and saving group
//     final bool isHaveContribution = user.contribution != -1.0;
//     final currentUser = Provider.of<AuthService>(context).user;

//     void onEdit() {
//       // Implement the edit functionality
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => UpdateMemberScreen(member: member)),
//       );
//     }

//     Future showDeleteConfirmationDialog() async {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Delete Confirmation'),
//             content: const Text('Are you sure you want to delete this member?'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Future.microtask(() async {
//                     final memberService =
//                         Provider.of<MemberService>(context, listen: false);
//                     await handleMainPageApi(context, () async {
//                       return await memberService.deleteMember(member.membername);
//                       // return result;
//                     }, () async {
//                       Navigator.of(context).pop();
//                     });
//                   });
//                   // onDelete();
//                 },
//                 child: const Text('Delete'),
//               ),
//             ],
//           );
//         },
//       );
//     }

//     // double progress = member.contribution / maxContribution; // Calculate the progress as a fraction
//     String formattedDate = timeago.format(DateTime.parse(member.creationDate));
//     final colorScheme = Theme.of(context).colorScheme;
//     return Card(
//       color: colorScheme.tertiary,
//       shadowColor: colorScheme.secondary.withOpacity(0.5),
//       elevation: 5,
//       child: InkWell(
//         splashColor: colorScheme.quaternary,
//         onTap: () {
//           // debugPrint('Challenge tapped.');
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return MemberDetail(member: member);
//           }));
//         },
//         borderRadius: BorderRadius.circular(16),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Row(
//                 children: [
//                   // CustomCircleAvatar(imagePath: member.avatarPath),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       "${member.membername} ${currentUser?.membername == member.membername ? '(You)' : ''}",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.edit, color: colorScheme.secondary),
//                     onPressed: onEdit,
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete, color: colorScheme.secondary),
//                     onPressed: () async {
//                       await showDeleteConfirmationDialog();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Expanded(
//                       flex: 6,
//                       child: Text.rich(
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         TextSpan(
//                           children: isHaveContribution
//                               ? <TextSpan>[
//                                   TextSpan(
//                                     text: 'Contribute ',
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium!,
//                                   ),
//                                   TextSpan(
//                                     // text: '\$${member.contribution.toStringAsFixed(2)}',
//                                     text: "Member Contribution",
//                                     style: AppTextStyles.paragraphBold(context),
//                                   ),
//                                 ]
//                               : <TextSpan>[
//                                   TextSpan(
//                                     // text: '\$${member.contribution.toStringAsFixed(2)}',
//                                     text: member.fullname,
//                                     style: AppTextStyles.paragraphBold(context),
//                                   )
//                                 ],
//                         ),
//                       )),
//                   const SizedBox(width: 3),
//                   Text(
//                     "Joined $formattedDate",
//                     style: Theme.of(context).textTheme.bodySmall!,
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(4),
//                 child: isHaveContribution
//                     ? LinearProgressIndicator(
//                         // value: progress.clamp(0.0, 1.0), // Ensuring the value is between 0 and 1
//                         value: 0.4, // Ensuring the value is between 0 and 1
//                         backgroundColor: colorScheme.quaternary,
//                         valueColor:
//                             AlwaysStoppedAnimation<Color>(colorScheme.primary),
//                         minHeight: 8,
//                       )
//                     : Container(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
