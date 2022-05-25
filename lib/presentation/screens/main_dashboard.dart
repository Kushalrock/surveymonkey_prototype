import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ironsource_x/ironsource.dart';
import 'package:flutter_ironsource_x/models.dart';
import 'package:surveymonkey_prototype/logic/cubit/question_cubit.dart';
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
    // TODO: implement initState
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
      appBar: AppBar(
        title: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: const Icon(Icons.account_circle_rounded),
          ),
          const Text("Survey RPG"),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.balance),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text("200"),
                  ),
                ],
              ),
            ],
          )
        ]),
      ),
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(fontSize: 40),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<QuestionCubit>().getQuestionRequested();
                      Navigator.of(context).pushNamed('/add-data');
                    },
                    child: const Text(
                      'Add Data',
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
    );
  }
}
