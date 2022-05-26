import 'package:intl/intl.dart';
import 'package:surveymonkey_prototype/data/models/transaction_history_model.dart';

import '../data-provider/transaction_history_api.dart';
import 'package:intl/intl_browser.dart';

class TransactionHistoryRepository {
  final TransactionHistoryAPI transactionHistoryAPI = TransactionHistoryAPI();
  Future<List<TransactionHistoryModel>> getTransactionHistory() async {
    try {
      await findSystemLocale();
      final rawTransactionHistory =
          await transactionHistoryAPI.getTransactionHistory();
      return castToTransactionHistoryModel(rawTransactionHistory);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  List<TransactionHistoryModel> castToTransactionHistoryModel(
      Map<String, dynamic>? rawTransactionHistory) {
    List<TransactionHistoryModel> returnList = [];

    if (rawTransactionHistory != null) {
      rawTransactionHistory.forEach((key, value) {
        final DateTime timeStamp =
            DateTime.fromMillisecondsSinceEpoch(int.parse(key) * 1000);
        returnList.add(TransactionHistoryModel(
            DateFormat.yMMMd().add_jm().format(timeStamp).toString(), value));
      });
    }
    return returnList;
  }
}
