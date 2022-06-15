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
      appBar: AppBar(
        title: const Text(''),
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
                              .length >
                          0
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
                      child: IconButton(
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
                    ),
                    SizedBox(
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UpdateData(
                                    currentData: FirebaseAuth
                                        .instance.currentUser!.displayName
                                        .toString(),
                                    typeOfData: 'Password',
                                    funcOnSuccess: context
                                        .read<AuthCubit>()
                                        .updatePassword,
                                  )));
                        },
                        icon: const Icon(Icons.password_outlined),
                        tooltip: "Change Password",
                      ),
                    ),
                    SizedBox(
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_forever_outlined),
                        tooltip: "Delete Account",
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
                                  padding:
                                      EdgeInsets.fromLTRB(20, 10.0, 20, 10),
                                  child: Text(
                                    "Visit our website",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "www.coinkick.com",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white60,
                                    ),
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
                                  padding:
                                      EdgeInsets.fromLTRB(20, 10.0, 20, 10),
                                  child: Text(
                                    "        Support       ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "  Drop a mail today  ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white60,
                                    ),
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
                    top: 50,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                    child: Column(
                      children: const [
                        Text("To contact us, drop us a mail at"),
                        Text("support@coinkick.com")
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
    );
  }
}
