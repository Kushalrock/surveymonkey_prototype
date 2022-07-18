import 'package:intl/intl.dart';
import 'package:surveymonkey_prototype/data/models/transaction_history_model.dart';

import '../data-provider/transaction_history_api.dart';

class TransactionHistoryRepository {
  final TransactionHistoryAPI transactionHistoryAPI = TransactionHistoryAPI();
  Future<List<TransactionHistoryModel>> getTransactionHistory() async {
    try {
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
        if (returnList.length >= 100) {
          return;
        }
        final DateTime timeStamp = DateTime.parse(key.toString());
        returnList.add(TransactionHistoryModel(
            DateFormat.yMMMd().add_jm().format(timeStamp).toString(), value));
      });
    }
    for (var item in returnList) {
      print(item.transactionText);
    }
    return returnList;
  }
}
