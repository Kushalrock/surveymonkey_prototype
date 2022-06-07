import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ironsource_x/ironsource.dart';
import 'package:flutter_ironsource_x/models.dart';
import 'package:surveymonkey_prototype/logic/cubit/get_coins_cubit.dart';
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
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => context.read<GetCoinsCubit>().getCoins());
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

  void showSurvey() {
    context.read<QuestionCubit>().getQuestionRequested();
    Navigator.of(context).pushNamed('/add-data');
  }

  void showCashout() {}

  @override
  void onRewardedVideoAdClosed() {
    print("onRewardedVideoAdClosed");
    context.read<AuthCubit>().addCoins(10, "10 coins from rewarded ad");
  }

  Container GetDashboardCard(
      String headingText, String buttonText, funcOnPressed,
      {Color cardColor = const Color.fromARGB(255, 149, 83, 87)}) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                headingText,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                funcOnPressed();
              },
              child: Text(buttonText),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                primary: Color.fromARGB(255, 255, 0, 0),
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: cardColor,
      ),
    );
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
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: BlocBuilder<GetCoinsCubit, GetCoinsState>(
                        builder: (context, state) => Text(
                          "Account Balance: ",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: BlocBuilder<GetCoinsCubit, GetCoinsState>(
                          builder: (context, state) {
                        if (state is CoinsLoading) {
                          return Text(
                            "NaN",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          );
                        } else if (state is CoinsFetched) {
                          return Text(
                            "${state.userCoins} coins",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          );
                        }
                        return Text(
                          "Error",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Divider(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Welcome Michael,",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: Row(
                      children: [
                        GetDashboardCard(
                            "Survey Available", "Take the survey", showSurvey),
                        GetDashboardCard(
                            "Offerwall", "Show Offerwall", showOfferwall)
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ),
                  Row(
                    children: [
                      GetDashboardCard("Video Available", "Show Rewarded Ad",
                          showRewardedAd),
                      GetDashboardCard("Cashout", "Cashout Money", showCashout)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            label: "Home",
            backgroundColor: Colors.white70,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            label: "Transactions",
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_outlined),
            backgroundColor: Colors.purple,
            label: "Cashout",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            backgroundColor: Colors.purple,
            label: "Profile",
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            Navigator.of(context).pushNamed("/transaction-history");
          } else if (index == 3) {
            Navigator.of(context).pushNamed("/profile");
          }
        },
      ),
    );
  }
}
