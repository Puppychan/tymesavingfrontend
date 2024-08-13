import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/full_screen_image.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';
import 'package:tymesavingfrontend/services/budget_service.dart';
import 'package:tymesavingfrontend/services/transaction_service.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class BudgetApprovePage extends StatefulWidget {
  const BudgetApprovePage({super.key, required this.budgetId});
  final String budgetId;

  @override
  State<BudgetApprovePage> createState() => _BudgetApprovePageState();
}

class _BudgetApprovePageState extends State<BudgetApprovePage> with RouteAware {
  List<Transaction> _awaitingApprovalTransaction = [];
  List<Transaction> _cancelledTransaction = [];
  bool showingPending = true;
  bool isLoading = true;

  Future<void> _loadTransactions() async {
    if (!mounted) return;
    final budgetService = Provider.of<BudgetService>(context, listen: false);
    await handleMainPageApi(context, () async {
      return await budgetService.fetchAwaitingApprovalTransactions(widget.budgetId);
    }, () async {
      if (!mounted) return;
      setState(() {
        _awaitingApprovalTransaction = budgetService.awaitingApprovalTransaction;
        _cancelledTransaction = budgetService.cancelledTransaction;
        isLoading = false;
      });
    });
  }

  void _showSuccess(String message) {
  if (mounted) {
    SuccessDisplay.showSuccessToast(message, context);
  }
}

  @override
  void initState() {
    isLoading = true;
    _loadTransactions();
    super.initState();
  }

  @override
    void didPopNext() {
      super.didPopNext();
      isLoading = true;
      _loadTransactions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const Heading(title: "Approval page"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              (showingPending) ? "Pending Transaction" : "Declined Transaction",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showingPending = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      color: showingPending
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      child: Text(
                        'Pending',
                        style: TextStyle(
                          color: showingPending
                              ? Colors.white
                              : Colors.black,
                          fontWeight: showingPending
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showingPending = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      color: !showingPending
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      child: Text(
                        'Canceled',
                        style: TextStyle(
                          color: !showingPending
                              ? Colors.white
                              : Colors.black,
                          fontWeight: !showingPending
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            isLoading ? 
            const Padding(
              padding: EdgeInsets.all(15),
              child: CircularProgressIndicator(),
            ) :
            Expanded(
              child: showingPending ?
              ListView.builder(
                itemCount: _awaitingApprovalTransaction.length,
                itemBuilder: (context, index) {
                  final transaction = _awaitingApprovalTransaction[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () => _showAcceptDeclinePrompt(context, this, transaction.transactionImage, transaction.id),
                      tileColor: colorScheme.tertiary,
                      title: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text.rich(
                          TextSpan(
                            text: 'Transaction', // Default text style
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' Pending',
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.green, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${transaction.user!.fullname} (${transaction.user!.username})', style: Theme.of(context).textTheme.bodyMedium),
                            Text('${transaction.category} (category)', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic)),
                            Text.rich(
                              TextSpan(
                                text: 'Amount ', // Default text style
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: formatAmountToVnd(transaction.amount),
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Text(transaction.description ?? '', style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.visible,),
                        
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )

              : ListView.builder(
                itemCount: _cancelledTransaction.length,
                itemBuilder: (context, index) {
                  final transaction = _cancelledTransaction[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: colorScheme.tertiary,
                      title: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text.rich(
                          TextSpan(
                            text: 'Transaction', // Default text style
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' Cancelled',
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${transaction.user!.fullname} (${transaction.user!.username})', style: Theme.of(context).textTheme.bodyMedium),
                            Text('${transaction.category} (category)', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic)),
                            Text.rich(
                              TextSpan(
                                text: 'Amount ', // Default text style
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: formatAmountToVnd(transaction.amount),
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Text(transaction.description ?? '', style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.visible,),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ) 
          ],
        ),
      ),
    );
  }

  void _showAcceptDeclinePrompt(BuildContext context, _BudgetApprovePageState state, String? transactionImage, String transactionId) {
    final transactionService = Provider.of<TransactionService>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm", style: Theme.of(context).textTheme.headlineSmall),
          content: Text("Do you approve or decline this transaction?", style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.visible),
          actions: <Widget>[
            if (transactionImage != null)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(imageUrl: transactionImage),
                    ),
                  );
                },
                child: Image.network(transactionImage),
              )
            else
              const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    "Accept",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await transactionService.approveTransaction(transactionId);
                    isLoading = true;
                    await _loadTransactions();
                    _showSuccess('Successfully approve transaction');
                  },
                ),
                TextButton(
                  child: Text(
                    "Decline",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await transactionService.cancelledTransaction(transactionId);
                    isLoading = true;
                    await _loadTransactions();
                    _showSuccess('Successfully decline transaction');
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

