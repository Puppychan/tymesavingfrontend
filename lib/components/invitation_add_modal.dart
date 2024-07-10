import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';
import 'package:tymesavingfrontend/components/search_user_delegate.dart';

void showUserInputModal(BuildContext context) {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  showStyledBottomSheet(
    context: context,
    contentWidget: Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  final selectedUser = await showSearch(
                    context: context,
                    delegate: UserSearchDelegate(),
                  );
                  if (selectedUser != null) {
                    usernameController.text = selectedUser;
                    // Fetch additional details for the selected user and populate other fields
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          UnderlineTextField(
            controller: descriptionController,
            label: 'Description',
            placeholder: "Any message for this invitation?",

          ),
        
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle form submission
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      )),
    ),
  );
}
