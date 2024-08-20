import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/full_screen_image.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/components/transaction/infor_row.dart';
import 'package:tymesavingfrontend/screens/transaction/transaction_update_page.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(widget.transaction.category,
              style: Theme.of(context).textTheme.headlineMedium),
          content: SizedBox(
            width: constraints.maxWidth * 0.8, // 80% of screen width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Description",
                  style: Theme.of(context).textTheme.headlineMedium,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: InkWell(
                      onTap: () {
                        // Action to view the rest of the description. This could open a dialog, a new page, or expand the text in place.
                        setState(() {
                          _isDisplayRestDescription =
                              !_isDisplayRestDescription;
                        });
                      },
                      child: widget.transaction.description!.isEmpty ?
                      Text('This transaction has no description!'
                      , style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic),)
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.transaction.description!,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.justify,
                            maxLines: _isDisplayRestDescription ? null : 2,
                            overflow: _isDisplayRestDescription
                                ? TextOverflow.visible
                                : TextOverflow.fade,
                          ),
                          if (!_isDisplayRestDescription)
                            Text(
                              "Tap for more",
                              style: Theme.of(context).textTheme.labelMedium,
                            )
                        ],
                      )),
                ),
                if (widget.transaction.transactionImages.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: widget.transaction.transactionImages.length,
                    itemBuilder: (context, index) {
                      final imageURL = widget.transaction.transactionImages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            Text('Receipt image ${index+1}', style: Theme.of(context).textTheme.headlineMedium,),
                            const SizedBox(height: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(imageUrl: imageURL),
                                  ),
                                );
                              },
                              child: Image.network(
                              imageURL,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child; // The image has finished loading.
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                          : null,
                                    ),
                                  );
                                }
                              },
                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                return const Center(
                                  child: Icon(Icons.error), // You can show an error icon if the image fails to load.
                                );
                              },
                              ),
                            ),
                            const SizedBox(height: 10,),
                          ],
                        )
                      );
                    }
                  ),
                )
              ],
            ),
          ),
          actions: [
            Row(
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
                  child: const Text('Edit'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Add your delete functionality here
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
            ),
          ],
        );
      },
    );
  }
}
