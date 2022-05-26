import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surveymonkey_prototype/logic/cubit/transaction_history_cubit.dart';

import '../../data/models/transaction_history_model.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);
  List<Card> cardWidgetList(
      List<TransactionHistoryModel> transactionModelList) {
    List<Card> returnList = [];
    for (var item in transactionModelList) {
      returnList.add(Card(
        elevation: 10,
        child: Column(children: [
          Text(
            item.transactionText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            item.date,
            style: TextStyle(color: Colors.grey),
          ),
        ]),
      ));
    }

    return returnList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction History"),
      ),
      body: BlocListener<TransactionHistoryCubit, TransactionHistoryState>(
        listener: (context, state) {
          if (state is TransactionHistoryError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Error occured while fetching transaction history")));
            // Navigate to the sign in screen when the user Signs Out
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<TransactionHistoryCubit, TransactionHistoryState>(
          builder: (context, state) {
            if (state is TransactionHistoryLoading) {
              return (CircularProgressIndicator());
            } else if (state is TransactionHistoryLoaded) {
              return state.transactionHistoryModel.isNotEmpty
                  ? ListView(
                      children: cardWidgetList(state.transactionHistoryModel),
                    )
                  : Text("No available transactions, Start earning now!");
            }
            return Container();
          },
        ),
      ),
    );
  }
}
