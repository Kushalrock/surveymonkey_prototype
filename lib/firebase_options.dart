// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBfSab3ZbHCqrndtimca_EPeP3DAaOVpEY',
    appId: '1:1076532495228:web:e19fff0d30f685a9525af9',
    messagingSenderId: '1076532495228',
    projectId: 'surveyrpg-prototype',
    authDomain: 'surveyrpg-prototype.firebaseapp.com',
    storageBucket: 'surveyrpg-prototype.appspot.com',
    measurementId: 'G-4S805TV81S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAuJvXx-RDsO4HAILnLXao_q4nrSp70CBk',
    appId: '1:1076532495228:android:d744e7e5c1679e03525af9',
    messagingSenderId: '1076532495228',
    projectId: 'surveyrpg-prototype',
    storageBucket: 'surveyrpg-prototype.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADJKPjOec_89ZfNMyV1f-Cqcfib2WF3xQ',
    appId: '1:1076532495228:ios:f9ae41556263094d525af9',
    messagingSenderId: '1076532495228',
    projectId: 'surveyrpg-prototype',
    storageBucket: 'surveyrpg-prototype.appspot.com',
    iosClientId: '1076532495228-rl3ck0f4effjq89v4d1qhc1ae0r9amk0.apps.googleusercontent.com',
    iosBundleId: 'com.example.surveymonkeyPrototype',
  );
}
