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
            color: Color.fromARGB(255, 18, 18, 18),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 18, 18, 18),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: BlocBuilder<GetCoinsCubit, GetCoinsState>(
              builder: (context, state) {
                if (state is CoinsFetched) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 40, 40, 40),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "You have got",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    BlocBuilder<GetCoinsCubit, GetCoinsState>(
                                        builder: (context, state) {
                                      if (state is CoinsLoading) {
                                        return const Text(
                                          "NaN",
                                          style: TextStyle(
                                            fontSize: 25,
                                          ),
                                        );
                                      } else if (state is CoinsFetched) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: Text(
                                            "${state.userCoins} Coins",
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      }
                                      return const Text(
                                        "Error",
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                                Image.asset(
                                  "assets/sign_in_screen_3.png",
                                  width: 110,
                                  height: 110,
                                ),
                              ],
                            ),
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
                              color: const Color.fromARGB(255, 40, 40, 40),
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
                              color: const Color.fromARGB(255, 40, 40, 40),
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
                              color: const Color.fromARGB(255, 40, 40, 40),
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
                              color: const Color.fromARGB(255, 40, 40, 40),
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
                              color: const Color.fromARGB(255, 40, 40, 40),
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
                          GestureDetector(
                            onTap: state.userCoins >= 11500
                                ? () {
                                    showPaypalAddressBox(
                                        context, 11500, "charity");
                                  }
                                : null,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: const Color.fromARGB(255, 40, 40, 40),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/charity_4.png',
                                      width: 80,
                                      height: 80,
                                    ),
                                    const SizedBox(
                                      width: 1,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "11500 coins",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "\$12",
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
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white70,
            ),
            label: "",
            backgroundColor: Color.fromARGB(255, 18, 18, 18),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_sharp,
              color: Colors.white70,
            ),
            label: "",
            backgroundColor: Color.fromARGB(255, 18, 18, 18),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet_sharp,
              color: Colors.white70,
            ),
            label: "",
            backgroundColor: Color.fromARGB(255, 18, 18, 18),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              color: Colors.white70,
            ),
            label: "",
            backgroundColor: Color.fromARGB(255, 18, 18, 18),
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
