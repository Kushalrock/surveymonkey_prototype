import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  Future<void> signUp({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      await signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (FirebaseAuth.instance.currentUser != null) {
        if (!FirebaseAuth.instance.currentUser!.emailVerified) {
          throw Exception('Email not verified');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else {
        throw Exception("Some error occured. Try Again");
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(displayName);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updatePassword(String password, String oldPassword) async {
    final cred = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email.toString(),
        password: oldPassword);
    try {
      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(cred);
      await FirebaseAuth.instance.currentUser?.updatePassword(password);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addCoins(int coins, String purposeText) async {
    final userData = FirebaseFirestore.instance.collection('/app-data');
    int previousCoins = 0;
    await userData
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) {
      if (value.exists) {
        previousCoins = value.data()!["coins"];
      } else {
        value.data()?.update("coins", (value) => value = 0, ifAbsent: () => 0);
        previousCoins = 0;
      }
    });
    var coinsData = {"coins": coins + previousCoins};
    await userData
        .doc(FirebaseAuth.instance.currentUser?.email)
        .set(coinsData, SetOptions(merge: true));
    FirebaseFirestore.instance
        .collection('/transaction-history')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .set({DateTime.now().millisecondsSinceEpoch.toString(): purposeText},
            SetOptions(merge: true));
  }
}
