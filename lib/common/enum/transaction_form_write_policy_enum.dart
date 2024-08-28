import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';

enum TransactionFormWritePolicy {
  createForm,
  updateForm,
  createFormFromGroup,
  // updateFormFromGroup
  viewOnly, //  use when user only can view the form - group case
}

  TransactionFormWritePolicy renderWritePermission(FormStateType formType, bool? isFromGroupDetailPage, bool isTransactionFromGroup) {
    if (formType == FormStateType.updateExpense ||
        formType == FormStateType.updateIncome) {
      if (isTransactionFromGroup == true) {
        // only allow to update images
        return TransactionFormWritePolicy.viewOnly;
      }
      // if not from group, allow to update all except group field
      return TransactionFormWritePolicy.updateForm;
    }
    // return FormWritePermission.viewOnly;
    if (isFromGroupDetailPage == true) {
      // if create form from group detail page,
      // not allow to edit group
      return TransactionFormWritePolicy.createFormFromGroup;
    }
    // allow to edit all
    return TransactionFormWritePolicy.createForm;
  }