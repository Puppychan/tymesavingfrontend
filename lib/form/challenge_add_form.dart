import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/components/common/input/underline_text_field.dart';

class ChallengeForm extends StatefulWidget {
  final FormStateType type;
  @override
  State<ChallengeForm> createState() => _ChallengeFormState();
}

class _ChallengeFormState extends State<ChallengeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _scopeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UnderlineTextField(
            controller: _nameController,
            icon: FontAwesomeIcons.inbox,
            label: 'Challenge NAME',
            placeholder: "Enter challenge name",
            keyboardType: TextInputType.text,
            onChange: (value) => updateOnChange("name"),
            validator: Validator.validateGroupName,
          ),
          UnderlineTextField(
            controller: _descriptionController,
            icon: FontAwesomeIcons.infoCircle,
            label: 'Description',
            placeholder: "Enter description",
            keyboardType: TextInputType.text,
            onChange: (value) => updateOnChange("description"),
            validator: Validator.validateDescription,
          ),
          UnderlineTextField(
            controller: _categoryController,
            icon: FontAwesomeIcons.tags,
            label: 'Category',
            placeholder: "Enter category",
            keyboardType: TextInputType.text,
            onChange: (value) => updateOnChange("category"),
            validator: Validator.validateCategory,
          ),
          UnderlineTextField(
            controller: _scopeController,
            icon: FontAwesomeIcons.globe,
            label: 'Scope',
            placeholder: "Enter scope",
            keyboardType: TextInputType.text,
            onChange: (value) => updateOnChange("scope"),
            validator: Validator.validateScope,
          ),
          UnderlineTextField(
            controller: _savingGroupIdController,
            icon: FontAwesomeIcons.piggyBank,
            label: 'Saving Group ID',
            placeholder: "Enter saving group ID",
            keyboardType: TextInputType.text,
            onChange: (value) => updateOnChange("savingGroupId"),
            validator: Validator.validateGroupId,
          ),
          UnderlineTextField(
            controller: _budgetGroupIdController,
            icon: FontAwesomeIcons.moneyBill,
            label: 'Budget Group ID',
            placeholder: "Enter budget group ID",
            keyboardType: TextInputType.text,
            onChange: (value) => updateOnChange("budgetGroupId"),
            validator: Validator.validateGroupId,
          ),
          SizedBox(height: 20),
        ]));
  }
}
