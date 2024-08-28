import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/components/challenge/challenge_card.dart';
import 'package:tymesavingfrontend/components/challenge/challenge_non_listing.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/challenge_model.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class ChallengePage extends StatefulWidget {
  final String? userId;
  final String? budgetGroupId;
  final String? savingGroupId;
  
  const ChallengePage(
      {super.key, required this.userId, this.budgetGroupId, this.savingGroupId});
  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> with RouteAware{
  List<ChallengeModel>? _challengeModelList;
  bool isLoading = true;
  String searchName = "";
  String sortCreatedDate = "ascending";
  String sortName = "ascending";

  Future<void> _loadChallengeList(String? userId) async {
    Future.microtask(() async {
      if (!mounted) return;
      final challengeService =
          Provider.of<ChallengeService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await challengeService.fetchChallengeList(widget.userId!, name: searchName, sortCreateDate: sortCreatedDate, sortName: sortName);
      }, () async {
        if (!mounted) return;
        setState(() {
          _challengeModelList = challengeService.challengeModelList!
          .where((element) => element.isPublished).toList();
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    _loadChallengeList(widget.userId);
    super.initState();
  }

  @override
    void didPopNext() {
      super.didPopNext();
      isLoading = true;
      _loadChallengeList(widget.userId);
  }

  @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
    }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: Heading(
        title: "Challenges",
        actions: [
         IconButton(onPressed: () {
          Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChallengeNonListing(userId: widget.userId!)));
         }, icon: const Icon(Icons.pending_actions_rounded))
        ],
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          children: [
            Text(
              "Spending money is hard, these challenges set by other user will help to reinforce your ability to spend money wisely!",
              maxLines: 3,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  labelText: 'Search',
                  helperText: 'Search by name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (String value) {
                  setState(() {
                    searchName = value.toString().trimRight();
                    isLoading = true;
                    _loadChallengeList(widget.userId);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: ElevatedButton(
                style: const ButtonStyle(
                  alignment: Alignment.center,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizeHeight * 0.02),
                  child: Text("Sorting", 
                    style: AppTextStyles.titleLargeBlue(context)),
                ),
                  onPressed: () => _showSortDialog(context),
              ),
            ),
            (isLoading)
                ? const CircularProgressIndicator()
                : Expanded(
                  child: SizedBox(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: RefreshIndicator(
                      onRefresh: () => _pullRefresh(),
                      child: ListView.builder(
                        itemCount: _challengeModelList!.length,
                        itemBuilder: (context, index) {
                          final challenge = _challengeModelList![index];
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ChallengeCard(challengeModel: challenge),
                          );
                        },
                      ),
                    ),
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      isLoading = true;
    });
    _loadChallengeList(widget.userId);
  }

   void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
       return AlertDialog(
        title: Text(
          'Sort Challenges',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Sort by created date',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
            ),
            DropdownButtonFormField<String>(
              value: sortCreatedDate,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: [
                DropdownMenuItem(
                  value: 'ascending',
                  child: Text('Ascending date', style: Theme.of(context).textTheme.bodyMedium),
                ),
                DropdownMenuItem(
                  value: 'descending',
                  child: Text('Descending date', style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  sortCreatedDate = value!;
                  isLoading = true;
                  Navigator.of(context).pop(); // Close the dialog
                  _loadChallengeList(widget.userId);
                });
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Sort by name',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
            ),
            DropdownButtonFormField<String>(
              value: sortName,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: [
                DropdownMenuItem(
                  value: 'ascending',
                  child: Text('Ascending name', style: Theme.of(context).textTheme.bodyMedium),
                ),
                DropdownMenuItem(
                  value: 'descending',
                  child: Text('Descending name', style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  sortName = value!;
                  isLoading = true;
                  Navigator.of(context).pop(); // Close the dialog
                  _loadChallengeList(widget.userId);
                });
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      );
      },
    );
  }
}
