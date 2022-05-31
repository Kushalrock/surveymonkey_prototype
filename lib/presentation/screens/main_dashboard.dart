import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ironsource_x/ironsource.dart';
import 'package:flutter_ironsource_x/models.dart';
import 'package:surveymonkey_prototype/logic/cubit/question_cubit.dart';
import 'package:surveymonkey_prototype/logic/cubit/transaction_history_cubit.dart';
import 'package:surveymonkey_prototype/presentation/screens/Signin_screen.dart';

import '../../logic/cubit/auth_cubit.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with IronSourceListener {
  bool offerWallAvailable = false;
  @override
  void initState() {
    super.initState();
    initIronSource();
  }

  Future<void> initIronSource() async {
    var userId = await IronSource.getAdvertiserId();
    await IronSource.validateIntegration();
    await IronSource.setUserId(userId);
    await IronSource.initialize(
        appKey: "14e479979",
        gdprConsent: true,
        ccpaConsent: false,
        listener: this);
    offerWallAvailable = await IronSource.isOfferwallAvailable();
  }

  void showOfferwall() async {
    if (await IronSource.isOfferwallAvailable()) {
      IronSource.showOfferwall();
    } else {
      print("Offerwall not available");
    }
  }

  @override
  void onOfferwallAdCredited(OfferwallCredit reward) {
    context
        .read<AuthCubit>()
        .addCoins(reward.credits!, "${reward.credits!} from offerwall");
  }

  void showRewardedAd() async {
    if (await IronSource.isRewardedVideoAvailable()) {
      IronSource.showRewardedVideo();
    } else {
      print(
        "wfbfbjwfbj",
      );
    }
  }

  @override
  void onRewardedVideoAdClosed() {
    print("onRewardedVideoAdClosed");
    context.read<AuthCubit>().addCoins(10, "10 coins from rewarded ad");
  }

  @override
  Widget build(BuildContext context) {
    // Getting the user from the FirebaseAuth Instance
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: null,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            // Navigate to the sign in screen when the user Signs Out
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => SignInScreen(),
              ),
              ModalRoute.withName('/'),
            );
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 9, 32, 63),
                Color.fromARGB(255, 83, 120, 149),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 280,
                    child: Stack(
                      children: [
                        Container(
                          child: Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Welcome Mike,",
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Your account balance is: ",
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              Text(
                                "300 coins",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          height: 200,
                        ),
                        Positioned(
                          child: Container(
                            height: 140,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Center(
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Today's survey is available!",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Answer questions",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<QuestionCubit>()
                                          .getQuestionRequested();
                                      Navigator.of(context)
                                          .pushNamed('/add-data');
                                    },
                                    child: Text("Take the survey"),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      primary: Color.fromARGB(255, 149, 83, 87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Color.fromARGB(255, 149, 112, 83),
                            ),
                          ),
                          bottom: 0,
                        ),
                      ],
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        showOfferwall();
                      },
                      child: const Text(
                        'Offerwall',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        showRewardedAd();
                      },
                      child: const Text(
                        'Rewarded Ad',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        context
                            .read<TransactionHistoryCubit>()
                            .transactionHistoryRequested();
                        Navigator.pushNamed(context, '/transaction-history');
                      },
                      child: const Text(
                        'Transaction History',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: const Text('Sign Out'),
                    onPressed: () {
                      // Signing out the user
                      context.read<AuthCubit>().signOutRequested();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_outlined),
            label: "",
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            backgroundColor: Colors.purple,
            label: "",
          ),
        ],
      ),
    );
  }
}
