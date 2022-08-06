import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ironsource_x/ironsource.dart';
import 'package:flutter_ironsource_x/models.dart';
import 'package:flutter_pollfish/flutter_pollfish.dart';
import 'package:in_app_update/in_app_update.dart';
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
  AppUpdateInfo? _updateInfo;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    initIronSource();
    initPollfish();
    checkForUpdate();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => context.read<GetCoinsCubit>().getCoins());
    WidgetsBinding.instance?.addPostFrameCallback((_) =>
        _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable
            ? () {
                InAppUpdate.performImmediateUpdate()
                    .catchError((e) => print(e.toString()));
              }
            : print("No updates Available"));
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

  @override
  void onOfferwallAdCredited(OfferwallCredit reward) {
    context
        .read<AuthCubit>()
        .addCoins(reward.credits!, "${reward.credits!} from offerwall");
    context.read<GetCoinsCubit>().getCoins();
  }

  void onPollfishSurveyCompleted(SurveyInfo? surveyInfo) {
    print(surveyInfo);
    int? rewardVal = surveyInfo?.rewardValue;
    if (rewardVal == 0 || rewardVal == null) {
      rewardVal = 50;
    }
    context.read<AuthCubit>().addCoins(
        rewardVal, "Won $rewardVal coins for completing third party survey.");
  }

  @override
  void onRewardedVideoAdClosed() {
    print("onRewardedVideoAdClosed");
    context.read<AuthCubit>().addCoins(10, "10 coins from rewarded ad");
    context.read<GetCoinsCubit>().getCoins();
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

  void showOfferwall() async {
    if (await IronSource.isOfferwallAvailable()) {
      IronSource.showOfferwall();
    } else {
      print("Offerwall not available");
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

  void showBrandOffers() {
    Navigator.of(context).pushNamed('/brand-offers');
  }

  Container getDashboardCard(
    Image image,
    String buttonText,
    funcOnPressed,
  ) {
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width * 0.45,
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: image,
            ),
            ElevatedButton(
              onPressed: () {
                funcOnPressed();
              },
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                primary: const Color.fromARGB(255, 64, 64, 64),
              ),
            ),
          ],
        ),
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        color: Color.fromARGB(255, 40, 40, 40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 18, 18, 18),
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
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 18, 18, 18)),
          child: Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.width * .05),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.93,
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 18, 18, 18),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Hello,",
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Michael 👋",
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: Row(
                      children: [
                        getDashboardCard(
                          Image.asset(
                            "assets/survey_2.png",
                            width: 100,
                            height: 100,
                          ),
                          "Add Data",
                          showSurvey,
                        ),
                        getDashboardCard(
                          Image.asset(
                            "assets/play_games.png",
                            width: 100,
                            height: 100,
                          ),
                          "Play games",
                          showOfferwall,
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ),
                  Row(
                    children: [
                      getDashboardCard(
                        Image.asset(
                          "assets/survey_1.png",
                          width: 100,
                          height: 100,
                        ),
                        "Answer Surveys",
                        showPollfish,
                      ),
                      getDashboardCard(
                        Image.asset(
                          "assets/brand.png",
                          width: 100,
                          height: 100,
                        ),
                        "Exclusive Offers",
                        showBrandOffers,
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        getDashboardCard(
                          Image.asset(
                            "assets/rewards.png",
                            width: 100,
                            height: 100,
                          ),
                          "Play Video",
                          showRewardedAd,
                        ),
                        getDashboardCard(
                          Image.asset(
                            "assets/roulette_wheel.png",
                            width: 100,
                            height: 100,
                          ),
                          "Try your luck",
                          showRoulette,
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
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet_sharp,
              color: Colors.white70,
            ),
            label: "",
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              color: Colors.white70,
            ),
            label: "",
            backgroundColor: Colors.purple,
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
