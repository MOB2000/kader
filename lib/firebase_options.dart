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
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCvnAwm3An4mPiuQrMB6F3K-JlcYunUaYE',
    appId: '1:219660533919:web:b50e7e360788301f3662aa',
    messagingSenderId: '219660533919',
    projectId: 'kader756',
    authDomain: 'kader756.firebaseapp.com',
    storageBucket: 'kader756.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCO4sE9EDLbIYnvRYmpjeG_gOMlJRtuuw4',
    appId: '1:219660533919:android:8d7bf50243f7e79b3662aa',
    messagingSenderId: '219660533919',
    projectId: 'kader756',
    storageBucket: 'kader756.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBihm4po9NwI1TZK7hRZJbEPeeIQfGJHFo',
    appId: '1:219660533919:ios:62064e171ffe38313662aa',
    messagingSenderId: '219660533919',
    projectId: 'kader756',
    storageBucket: 'kader756.appspot.com',
    iosClientId: '219660533919-9sdnv77bn8bnvlj1562cbk3gprpqbqc1.apps.googleusercontent.com',
    iosBundleId: 'com.example.kader',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBihm4po9NwI1TZK7hRZJbEPeeIQfGJHFo',
    appId: '1:219660533919:ios:6badc900b1ce4ffd3662aa',
    messagingSenderId: '219660533919',
    projectId: 'kader756',
    storageBucket: 'kader756.appspot.com',
    iosClientId: '219660533919-a02d9a178rn7bhdtcksk4881m7gia8mo.apps.googleusercontent.com',
    iosBundleId: 'com.example.kader.RunnerTests',
  );
}