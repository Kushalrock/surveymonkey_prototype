import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surveymonkey_prototype/logic/cubit/auth_cubit.dart';
import 'package:surveymonkey_prototype/presentation/screens/updatedata_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../logic/cubit/transaction_history_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  void _launchUrl(String urlStringVal) {
    launchUrlString(urlStringVal);
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
              Color.fromARGB(255, 83, 120, 149)
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(
                  Icons.account_circle_rounded,
                  size: 100,
                ),
                Text(
                  FirebaseAuth.instance.currentUser!.displayName
                          .toString()
                          .isNotEmpty
                      ? FirebaseAuth.instance.currentUser!.displayName
                          .toString()
                      : "",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(222, 255, 255, 255),
                  ),
                ),
                Text(
                  FirebaseAuth.instance.currentUser!.email.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(168, 255, 255, 255),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UpdateData(
                                        currentData: FirebaseAuth
                                            .instance.currentUser!.displayName
                                            .toString(),
                                        typeOfData: 'Display Name',
                                        funcOnSuccess: context
                                            .read<AuthCubit>()
                                            .updateDisplayName,
                                      )));
                            },
                            icon: const Icon(Icons.assessment_outlined),
                          ),
                          const Text("Change Name"),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UpdateData(
                                    currentData: FirebaseAuth
                                        .instance.currentUser!.displayName
                                        .toString(),
                                    typeOfData: 'Password',
                                    funcOnSuccess: context
                                        .read<AuthCubit>()
                                        .updatePassword,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.password_outlined),
                            tooltip: "Change Password",
                          ),
                          const Text("Change Password"),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.delete_forever_outlined),
                            tooltip: "Delete Account",
                          ),
                          const Text("Delete Account"),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.black),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.web_asset_outlined,
                                    size: 50,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                                  child: Text(
                                    "Visit our website",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _launchUrl("https://coinkick.app/");
                                    },
                                    child: const Text("Visit Website"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.black),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.contact_page_outlined,
                                    size: 50,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: Text(
                                    "Privacy Policy",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _launchUrl(
                                          "https://coinkick.app/privacypolicy/");
                                    },
                                    child: const Text("Visit T&S"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                    child: Column(
                      children: const [
                        Text("To contact us, drop us a mail at"),
                        Text("support@coinkick.app")
                      ],
                    ),
                  ),
                  color: const Color.fromARGB(255, 2, 24, 35),
                  elevation: 10,
                )
              ],
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
        currentIndex: 3,
        onTap: (int index) {
          if (index == 0) {
            while (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          } else if (index == 1) {
            context
                .read<TransactionHistoryCubit>()
                .transactionHistoryRequested();
            Navigator.of(context).pushNamed("/transaction-history");
          } else if (index == 2) {
            Navigator.of(context).pushNamed("/cashout");
          }
        },
      ),
    );
  }
}
