import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/dialog/delete_confirm_dialog.dart';
import 'package:tymesavingfrontend/components/full_screen_image.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/components/transaction/infor_row.dart';
import 'package:tymesavingfrontend/screens/main_page_layout.dart';
import 'package:tymesavingfrontend/screens/transaction/transaction_update_page.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class TransactionDialog extends StatefulWidget {
  final Transaction transaction;
  final String formattedDate;

  const TransactionDialog({
    super.key,
    required this.transaction,
    required this.formattedDate,
  });
  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  bool _isDisplayRestDescription = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final screenHeight = constraints.maxHeight;
      // final screenWidth = MediaQuery.of(context).size.width;
      final screenWidth = constraints.maxWidth;
      final isTransactionImagesEmpty =
          widget.transaction.transactionImages.isEmpty;

      return Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        // actions: [_buildDialogActions()],
        child: Container(
          width: screenWidth,
          height: isTransactionImagesEmpty
              ? screenHeight * 0.55
              : screenHeight * 0.7,
          padding: const EdgeInsets.symmetric(
              horizontal: 28.0, vertical: 32), // Padding inside the dialog
          child: Column(children: [
            _buildDialogHeading(),
            const SizedBox(height: 16),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicTransactionInfo(),
                  const SizedBox(height: 10),
                  const Divider(),
                  _buildDescription(),
                  if (!isTransactionImagesEmpty) ..._buildTransactionImages(),
                ],
              ),
            )),
            const SizedBox(height: 10),
            _buildDialogActions(),
          ]),
        ),
      );
    });
  }

  Widget _buildDialogHeading() {
    String title = "";
    if (widget.transaction.savingGroupId != null) {
      title = "From Saving Group";
    } else if (widget.transaction.budgetGroupId != null) {
      title = "From Budget Group";
    } else {
      title = "Personal Transaction";
    }
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .headlineMedium!
          .copyWith(fontWeight: FontWeight.w500),
    );
  }

  Widget _buildBasicTransactionInfo() {
    return Column(
      children: [
        InfoRow(
          icon: Icons.label,
          iconColor: Colors.indigo[600],
          label: 'Type:',
          value: widget.transaction.type,
        ),
        const SizedBox(height: 8),
        InfoRow(
          icon: Icons.category,
          iconColor: Colors.green[800],
          label: 'Category:',
          value: widget.transaction.category,
        ),
        const SizedBox(height: 8),
        InfoRow(
          icon: Icons.date_range,
          iconColor: Colors.orange[800],
          label: 'Date:',
          value: widget.formattedDate,
        ),
        const SizedBox(height: 8),
        InfoRow(
          icon: Icons.attach_money,
          iconColor: Colors.red[800],
          label: 'Amount:',
          value: formatAmountToVnd(widget.transaction.amount),
        ),
      ],
    );
  }

  // Build Description Section with Expandable Option
  Widget _buildDescription() {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            onTap: () {
              setState(() {
                _isDisplayRestDescription = !_isDisplayRestDescription;
              });
            },
            child: widget.transaction.description!.isEmpty
                ? Text(
                    'This transaction has no description!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontStyle: FontStyle.italic),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.transaction.description!,
                        style: textTheme.bodyMedium,
                        // textAlign: TextAlign.justify,
                        maxLines: _isDisplayRestDescription ? null : 2,
                        overflow: _isDisplayRestDescription
                            ? TextOverflow.visible
                            : TextOverflow.fade,
                      ),
                      if (!_isDisplayRestDescription)
                        Text(
                          "Tap for more",
                          style: textTheme.labelMedium,
                        )
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTransactionImages() {
    int index = -1;
    final textTheme = Theme.of(context).textTheme;
    return [
      const Divider(),
      Text(
        "Receipt Images",
        style: textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500),
      ),
      ...widget.transaction.transactionImages.map((imageURL) {
        index++;
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                Text(
                  'Receipt image ${index + 1}',
                  style: textTheme.bodyMedium!.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FullScreenImage(imageUrl: imageURL),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the radius as needed
                    child: Image.network(
                      imageURL,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // The image has finished loading.
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return const Center(
                          child: Icon(Icons
                              .error), // You can show an error icon if the image fails to load.
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ));
      })
    ];
  }

  Widget _buildDialogActions() {
    final isEditable = widget.transaction.savingGroupId == null &&
        widget.transaction.budgetGroupId == null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransactionUpdatePage(
                          transactionId: widget.transaction.id,
                        )));
            // Add your edit functionality here
          },
          child: Text(isEditable ? 'Edit' : 'Details'),
        ),
        if (isEditable)
          TextButton(
            onPressed: () {
              // Navigator.of(context).pop();
              // Add your delete functionality here
              showCustomDeleteConfirmationDialog(context,
                  "Are you sure you want to delete with this transaction?",
                  () async {
                final transactionSerivce =
                    Provider.of<TransactionService>(context, listen: false);
                await handleMainPageApi(context, () async {
                  return await transactionSerivce
                      .deleteTransaction(widget.transaction.id);
                }, () async {
                  //           Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  //   builder: (context) => MainPageLayout(
                  //       customPageIndex: isBudget ? PageLocation.budgetPage.index : PageLocation.savingPage.index),
                  // ),, (_) => false);
                });
              });
            },
            child: const Text('Delete'),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
