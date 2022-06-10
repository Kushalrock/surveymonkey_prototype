// CoreFlutter Imports
// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Firebase Related Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:surveymonkey_prototype/data/repositories/get_coins_repository.dart';
import 'package:surveymonkey_prototype/data/repositories/question_repository.dart';
import 'package:surveymonkey_prototype/data/repositories/transaction_history_repository.dart';
import 'package:surveymonkey_prototype/logic/cubit/get_coins_cubit.dart';
import 'package:surveymonkey_prototype/logic/cubit/question_cubit.dart';
import 'package:surveymonkey_prototype/logic/cubit/transaction_history_cubit.dart';
import 'package:surveymonkey_prototype/presentation/screens/adddata_questions_screen.dart';
import 'package:surveymonkey_prototype/presentation/screens/cashout_screen.dart';
import 'package:surveymonkey_prototype/presentation/screens/main_dashboard.dart';
import 'package:surveymonkey_prototype/presentation/screens/profile_page.dart';
import 'package:surveymonkey_prototype/presentation/screens/roulette_screen.dart';
import 'package:surveymonkey_prototype/presentation/screens/signup_screen.dart';
import 'package:surveymonkey_prototype/presentation/screens/transaction_history_screen.dart';

import 'firebase_options.dart';

// Other Packages Imports
import 'package:flutter_bloc/flutter_bloc.dart';

// Local Files Imports
import 'data/repositories/auth_repository.dart';
import 'logic/cubit/auth_cubit.dart';

import './presentation/screens/signin_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => QuestionRepository(),
        ),
        RepositoryProvider(
          create: (context) => TransactionHistoryRepository(),
        ),
        RepositoryProvider(
          create: (context) => GetCoinsRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(
                authRepository: RepositoryProvider.of<AuthRepository>(context)),
          ),
          BlocProvider(
            create: (context) => QuestionCubit(
                RepositoryProvider.of<QuestionRepository>(context)),
          ),
          BlocProvider(
            create: (context) => TransactionHistoryCubit(
                RepositoryProvider.of<TransactionHistoryRepository>(context)),
          ),
          BlocProvider(
            create: (context) => GetCoinsCubit(
                RepositoryProvider.of<GetCoinsRepository>(context)),
          ),
        ],
        child: MaterialApp(
          title: 'Coinkick',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            brightness: Brightness.dark,
          ),
          routes: {
            '/': (context) => StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Dashboard();
                    }
                    // Otherwise, they're not signed in. Show the sign in page.
                    return SignInScreen();
                  },
                ),
            '/sign-up': (context) => SignUpScreen(),
            '/dashboard': (context) => Dashboard(),
            '/add-data': (context) => QuestionsScreen(),
            '/profile': (context) => ProfilePage(),
            '/transaction-history': (context) => TransactionHistoryScreen(),
            '/cashout': (context) => CashoutScreen(),
            '/roulette': (context) => RouletteScreen(),
          },
        ),
      ),
    );
  }
}
