import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:surveymonkey_prototype/data/models/cashout_request_model.dart';
import 'package:surveymonkey_prototype/logic/cubit/auth_cubit.dart';

import '../../logic/cubit/get_coins_cubit.dart';

import '../../logic/cubit/transaction_history_cubit.dart';

class CashoutScreen extends StatefulWidget {
  const CashoutScreen({Key? key}) : super(key: key);

  @override
  State<CashoutScreen> createState() => _CashoutScreenState();
}

class _CashoutScreenState extends State<CashoutScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  void showPaypalAddressBox(
      BuildContext context, int coins, String purpose) async {
    if (purpose == "charity") {
      await context
          .read<AuthCubit>()
          .subtractCoins(coins, "Cashout requested for charity");
      context.read<GetCoinsCubit>().cashoutRequested(
            CashoutRequestModel(
                userEmail: FirebaseAuth.instance.currentUser?.email,
                moneyToBeGiven: coins,
                paypalEmail: "",
                purpose: purpose),
          );
      context.read<GetCoinsCubit>().getCoins();
      Navigator.pop(context);
      return;
    }
    Alert(
        context: context,
        title: "Cashout",
        content: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Paypal Email',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              context
                  .read<AuthCubit>()
                  .subtractCoins(coins, "Cashout requested for paypal");
              context.read<GetCoinsCubit>().cashoutRequested(
                  CashoutRequestModel(
                      userEmail: FirebaseAuth.instance.currentUser?.email,
                      moneyToBeGiven: coins,
                      paypalEmail: _textEditingController.text,
                      purpose: purpose));
              context.read<GetCoinsCubit>().getCoins();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "CASHOUT",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ]).show();
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
        child: Center(
          child: SingleChildScrollView(
            child: BlocBuilder<GetCoinsCubit, GetCoinsState>(
              builder: (context, state) {
                if (state is CoinsFetched) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 14, 36, 51),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          border: Border.all(color: Colors.white),
                        ),
                        width: MediaQuery.of(context).size.width * 0.93,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlocBuilder<GetCoinsCubit, GetCoinsState>(
                              builder: (context, state) {
                                if (state is CoinsLoading) {
                                  return const Text(
                                    "NaN",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  );
                                } else if (state is CoinsFetched) {
                                  return Text(
                                    "${state.userCoins} coins",
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  );
                                }
                                return const Text(
                                  "Error",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Paypal Cards",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: state.userCoins >= 5000
                                ? () {
                                    showPaypalAddressBox(
                                        context, 5000, "paypal");
                                  }
                                : null,
                            child: Card(
                              color: const Color.fromARGB(255, 14, 36, 51),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/paypal.png',
                                      width: 80,
                                      height: 80,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "5000 coins",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "\$5",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: state.userCoins >= 14500
                                ? () {
                                    showPaypalAddressBox(
                                        context, 14500, "paypal");
                                  }
                                : null,
                            child: Card(
                              color: const Color.fromARGB(255, 14, 36, 51),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/paypal.png',
                                      width: 80,
                                      height: 80,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "14500 coins",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "\$15",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Charity Cards",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: state.userCoins >= 2000
                                ? () {
                                    showPaypalAddressBox(
                                        context, 2000, "charity");
                                  }
                                : null,
                            child: Card(
                              color: const Color.fromARGB(255, 14, 36, 51),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/charity_1.png',
                                      width: 80,
                                      height: 80,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "2000 coins",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "\$2",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: state.userCoins >= 5000
                                ? () {
                                    showPaypalAddressBox(
                                        context, 5000, "charity");
                                  }
                                : null,
                            child: Card(
                              color: const Color.fromARGB(255, 14, 36, 51),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/charity_2.png',
                                      width: 80,
                                      height: 80,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "5000 coins",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "\$5",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: state.userCoins >= 10000
                                ? () {
                                    showPaypalAddressBox(
                                        context, 10000, "charity");
                                  }
                                : null,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: const Color.fromARGB(255, 14, 36, 51),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/charity_3.png',
                                      width: 80,
                                      height: 80,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "10000 coins",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "\$10",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (state is CoinsLoading) {
                  return const CircularProgressIndicator();
                }
                return Container();
              },
            ),
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
        currentIndex: 2,
        onTap: (int index) {
          if (index == 1) {
            context
                .read<TransactionHistoryCubit>()
                .transactionHistoryRequested();
            Navigator.of(context).pushNamed("/transaction-history");
          } else if (index == 3) {
            Navigator.of(context).pushNamed("/profile");
          } else if (index == 0) {
            while (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }
}
