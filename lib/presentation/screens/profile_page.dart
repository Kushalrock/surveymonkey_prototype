import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surveymonkey_prototype/logic/cubit/auth_cubit.dart';
import 'package:surveymonkey_prototype/presentation/screens/updatedata_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
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
                            .length >
                        0
                    ? FirebaseAuth.instance.currentUser!.displayName.toString()
                    : FirebaseAuth.instance.currentUser!.email.toString(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UpdateData(
                              currentData: FirebaseAuth
                                  .instance.currentUser!.displayName
                                  .toString(),
                              typeOfData: 'Display Name',
                              funcOnSuccess:
                                  context.read<AuthCubit>().updateDisplayName,
                            )));
                  },
                  child: const Text('Set Display Name'),
                ),
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UpdateData(
                              currentData: FirebaseAuth
                                  .instance.currentUser!.displayName
                                  .toString(),
                              typeOfData: 'Password',
                              funcOnSuccess:
                                  context.read<AuthCubit>().updatePassword,
                            )));
                  },
                  child: const Text('Update Password'),
                ),
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Delete Account'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                ),
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
