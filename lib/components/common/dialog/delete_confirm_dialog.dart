    import 'package:flutter/material.dart';

Future showCustomDeleteConfirmationDialog(BuildContext context, String confirmMessage, Future<void> Function()  onConfirm) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Remove Confirmation'),
            content: Text(confirmMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Future.microtask(() async {
                    await onConfirm();
                  });
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }