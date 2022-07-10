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
        elevation: 90,
        color: Color.fromARGB(255, 14, 36, 51),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              item.transactionText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              item.date,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ]),
      ));
    }

    return returnList;
  }

  void showCashout(BuildContext context) {
    Navigator.of(context).pushNamed('/cashout');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CoinKick'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              colors: <Color>[
                Color.fromARGB(255, 9, 32, 63),
                Color.fromARGB(255, 83, 120, 149)
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 9, 32, 63),
              Color.fromARGB(255, 83, 120, 149),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
          ),
        ),
        child: BlocListener<TransactionHistoryCubit, TransactionHistoryState>(
          listener: (context, state) {
            if (state is TransactionHistoryError) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "Error occured while fetching transaction history")));
              // Navigate to the sign in screen when the user Signs Out
              Navigator.of(context).pop();
            }
          },
          child: BlocBuilder<TransactionHistoryCubit, TransactionHistoryState>(
            builder: (context, state) {
              if (state is TransactionHistoryLoading) {
                return (const CircularProgressIndicator());
              } else if (state is TransactionHistoryLoaded) {
                return state.transactionHistoryModel.isNotEmpty
                    ? ListView(
                        children: cardWidgetList(state.transactionHistoryModel),
                      )
                    : const Text(
                        "No available transactions, Start earning now!");
              }
              return Container();
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.white70,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_sharp),
            label: "Transactions",
            backgroundColor: Colors.white70,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_sharp),
            backgroundColor: Colors.white70,
            label: "Cashout",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            backgroundColor: Colors.white70,
            label: "Profile",
          ),
        ],
        currentIndex: 1,
        onTap: (int index) {
          if (index == 0) {
            Navigator.of(context).pushNamed("/dashboard");
          } else if (index == 3) {
            Navigator.of(context).pushNamed("/profile");
          } else if (index == 2) {
            showCashout(context);
          }
        },
      ),
    );
  }
}
