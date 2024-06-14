import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tymesavingfrontend/models/transaction.model.dart';

class TransactionService {
  static const String _apiEndpoint =
      'https://tyme-saving-backend.vercel.app/api/transaction/byUser/72e4b93000be75dd6e367723';

  Future<Map<String, List<Transaction>>> fetchTransactions() async {
    final response = await http.get(Uri.parse(_apiEndpoint));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Raw JSON response: $data');

      final responseData = data['response'] as Map<String, dynamic>;
      print('Parsed response data: $responseData');

      return responseData.map((month, transactions) {
        final transactionList = (transactions['transactions'] as List<dynamic>)
            .map((transaction) => Transaction.fromJson(transaction))
            .toList();

        print('Transactions for $month: $transactionList');

        return MapEntry(month, transactionList);
      });
    } else {
      print('Failed to load transactions. Status code: ${response.statusCode}');
      throw Exception('Failed to load transactions');
    }
  }
}
