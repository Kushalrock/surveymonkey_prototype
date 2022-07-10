import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ironsource_x/ironsource.dart';
import 'package:flutter_ironsource_x/models.dart';
import 'package:flutter_pollfish/flutter_pollfish.dart';
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
    initPollfish();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => context.read<GetCoinsCubit>().getCoins());
  }

  @override
  void dispose() {
    FlutterPollfish.instance.removeListeners();

    super.dispose();
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

  Future<void> initPollfish() async {
    FlutterPollfish.instance.init(
        androidApiKey: "feadb6a1-4534-4a5f-959e-3173c680bde3",
        iosApiKey: null,
        indicatorPosition: Position.topLeft,
        rewardMode: true,
        releaseMode: false,
        offerwallMode: false);
    FlutterPollfish.instance
        .setPollfishSurveyCompletedListener(onPollfishSurveyCompleted);
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
    context.read<GetCoinsCubit>().getCoins();
  }

  void onPollfishSurveyCompleted(SurveyInfo? surveyInfo) {
    print(surveyInfo);
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

  void showCashout() {
    Navigator.of(context).pushNamed('/cashout');
  }

  Future<void> showRoulette() async {
    bool canPlayRoulette =
        await context.read<QuestionCubit>().canPlayRoulette();
    if (canPlayRoulette) {
      Navigator.of(context).pushNamed('/roulette');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("You have played Roulette recently. Come back later!")));
    }
  }

  void showPollfish() async {
    await FlutterPollfish.instance.show();
  }

  @override
  void onRewardedVideoAdClosed() {
    print("onRewardedVideoAdClosed");
    context.read<AuthCubit>().addCoins(10, "10 coins from rewarded ad");
    context.read<GetCoinsCubit>().getCoins();
  }

  Container GetDashboardCard(
      String headingText, String buttonText, funcOnPressed,
      {Color cardColor = const Color.fromARGB(255, 149, 83, 87)}) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width * 0.45,
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                headingText,
                style: const TextStyle(
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
                  side: BorderSide(color: Colors.blue),
                ),
                primary: const Color.fromARGB(255, 174, 198, 207),
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(color: Colors.white),
        color: cardColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Getting the user from the FirebaseAuth Instance

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
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            // Navigate to the sign in screen when the user Signs Out
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => const SignInScreen(),
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
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
            ),
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: BlocBuilder<GetCoinsCubit, GetCoinsState>(
                          builder: (context, state) {
                        if (state is CoinsLoading) {
                          return const Text(
                            "NaN",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          );
                        } else if (state is CoinsFetched) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 20),
                            child: Text(
                              "${state.userCoins} Coins",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          );
                        }
                        return const Text(
                          "Error",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        );
                      }),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Divider(
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * .05),
                  Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.93,
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 14, 36, 51),
                          border: Border.all(color: Colors.white),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Welcome, Michael",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "Login Streak: 1 day",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: Row(
                      children: [
                        GetDashboardCard(
                          "CoinKick Surveys",
                          "Add Data",
                          showSurvey,
                          cardColor: Color.fromARGB(255, 14, 36, 51),
                        ),
                        GetDashboardCard(
                          "Play Games",
                          "Earn Coin",
                          showOfferwall,
                          cardColor: Color.fromARGB(255, 14, 36, 51),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ),
                  Row(
                    children: [
                      GetDashboardCard(
                        "Third-Party Surveys",
                        "Earn Coin",
                        showPollfish,
                        cardColor: Color.fromARGB(255, 14, 36, 51),
                      ),
                      GetDashboardCard(
                        "Weekly Roulette",
                        "Try your luck",
                        showRoulette,
                        cardColor: Color.fromARGB(255, 14, 36, 51),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        GetDashboardCard(
                          "Rewarded Ads",
                          "Play Video",
                          showRewardedAd,
                          cardColor: Color.fromARGB(255, 14, 36, 51),
                        ),
                        GetDashboardCard(
                          "Roulette",
                          "Try your luck",
                          showRoulette,
                          cardColor: Color.fromARGB(255, 14, 36, 51),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
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
            icon: Icon(Icons.account_balance_sharp),
            label: "Transactions",
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_sharp),
            backgroundColor: Colors.purple,
            label: "Cashout",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            backgroundColor: Colors.purple,
            label: "Profile",
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            context
                .read<TransactionHistoryCubit>()
                .transactionHistoryRequested();
            Navigator.of(context).pushNamed("/transaction-history");
          } else if (index == 3) {
            Navigator.of(context).pushNamed("/profile");
          } else if (index == 2) {
            showCashout();
          }
        },
      ),
    );
  }
}
