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
  List<Transaction> _approvedTransaction = [];
  bool showingPending = true;
  bool showingCanceled = false;
  bool showingApproved = false;
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
        _approvedTransaction = budgetService.transactions;
        isLoading = false;
      });
    });
  }

  void _changeLoading(){
    if(!mounted) return;
    setState(() {
      isLoading = true;
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
      appBar: const Heading(
          title: "Budget Approval page", 
          showBackButton: true,
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              (showingPending) ? "Pending Transaction" : (showingApproved? "Approved Transaction" : "Declined Transaction"),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showingCanceled = false;
                        showingPending = false;
                        showingApproved = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      color: showingApproved
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      child: Text(
                        'Approved',
                        style: TextStyle(
                          color: showingApproved
                              ? Colors.white
                              : Colors.black,
                          fontWeight: showingApproved
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
                        showingPending = true;
                        showingApproved = false;
                        showingCanceled = false;
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
                        showingCanceled = true;
                        showingApproved = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      color: showingCanceled
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      child: Text(
                        'Canceled',
                        style: TextStyle(
                          color: showingCanceled
                              ? Colors.white
                              : Colors.black,
                          fontWeight: showingCanceled
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
              RefreshIndicator(
                onRefresh: _pullRefresh,
                child: ListView.builder(
                  itemCount: _awaitingApprovalTransaction.length,
                  itemBuilder: (context, index) {
                    final transaction = _awaitingApprovalTransaction[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () => _showAcceptDeclinePrompt(context, this, transaction.transactionImages, transaction.id),
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
                ),
              )
              : (showingCanceled ? RefreshIndicator(
                onRefresh: _pullRefresh,
                child: ListView.builder(
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
              ): RefreshIndicator(
                onRefresh: _pullRefresh,
                child: ListView.builder(
                  itemCount: _approvedTransaction.length,
                  itemBuilder: (context, index) {
                    final transaction = _approvedTransaction[index];
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
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w500),
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
              ))
            ) 
          ],
        ),
      ),
    );
  }

void _showAcceptDeclinePrompt(BuildContext context, _BudgetApprovePageState state, List<String> transactionImages, String transactionId) {
  final transactionService = Provider.of<TransactionService>(context, listen: false);
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Confirm",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Do you approve or decline this transaction?",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                ),
              ),
              const SizedBox(height: 16),
              if (transactionImages.isNotEmpty)
                SizedBox(
                  height: 180, // Set the height for the container holding the images
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Horizontal scrolling
                    itemCount: transactionImages.length,
                    itemBuilder: (context, index) {
                      final imageUrl = transactionImages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Text(
                              'Picture ${index + 1}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(imageUrl: imageUrl),
                                  ),
                                );
                              },
                              child: Image.network(
                                imageUrl,
                                height: 120, // Adjust the height as needed
                                width: 120, // Adjust the width as needed
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              else
                const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Text(
                        "Accept",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        _changeLoading();
                        await transactionService.approveTransaction(transactionId);
                        await _loadTransactions();
                        _showSuccess('Successfully approved transaction');
                      },
                    ),
                    TextButton(
                      child: Text(
                        "Decline",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        _changeLoading();
                        await transactionService.cancelledTransaction(transactionId);
                        await _loadTransactions();
                        _showSuccess('Successfully declined transaction');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  Future<void> _pullRefresh() async {
    setState(() {
      isLoading = true;
    });
    _loadTransactions();
  }
}

