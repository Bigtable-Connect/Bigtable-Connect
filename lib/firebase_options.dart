// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
///
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
        return windows;
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
    apiKey: 'AIzaSyAZuA2CoPUNgil55Fjc2TbKupLooIiclG4',
    appId: '1:586592318920:web:4a25fb9bc4355febc53cfd',
    messagingSenderId: '586592318920',
    projectId: 'arogyasair-b7bb5',
    authDomain: 'arogyasair-b7bb5.firebaseapp.com',
    databaseURL: 'https://arogyasair-b7bb5-default-rtdb.firebaseio.com',
    storageBucket: 'arogyasair-b7bb5.appspot.com',
    measurementId: 'G-W784RHPQ98',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxt2_HAugXvbs-25Lyqf00Qc7J2LMucL0',
    appId: '1:586592318920:android:f482be8f1c4c52a6c53cfd',
    messagingSenderId: '586592318920',
    projectId: 'arogyasair-b7bb5',
    databaseURL: 'https://arogyasair-b7bb5-default-rtdb.firebaseio.com',
    storageBucket: 'arogyasair-b7bb5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-55_DN3IEPXIX6uNOqwV-L2knqqdBOkc',
    appId: '1:586592318920:ios:3659d0be82acbcfec53cfd',
    messagingSenderId: '586592318920',
    projectId: 'arogyasair-b7bb5',
    databaseURL: 'https://arogyasair-b7bb5-default-rtdb.firebaseio.com',
    storageBucket: 'arogyasair-b7bb5.appspot.com',
    iosBundleId: 'com.example.bigtableConnect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA-55_DN3IEPXIX6uNOqwV-L2knqqdBOkc',
    appId: '1:586592318920:ios:3659d0be82acbcfec53cfd',
    messagingSenderId: '586592318920',
    projectId: 'arogyasair-b7bb5',
    databaseURL: 'https://arogyasair-b7bb5-default-rtdb.firebaseio.com',
    storageBucket: 'arogyasair-b7bb5.appspot.com',
    iosBundleId: 'com.example.bigtableConnect',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAZuA2CoPUNgil55Fjc2TbKupLooIiclG4',
    appId: '1:586592318920:web:4a25fb9bc4355febc53cfd',
    messagingSenderId: '586592318920',
    projectId: 'arogyasair-b7bb5',
    authDomain: 'arogyasair-b7bb5.firebaseapp.com',
    databaseURL: 'https://arogyasair-b7bb5-default-rtdb.firebaseio.com',
    storageBucket: 'arogyasair-b7bb5.appspot.com',
    measurementId: 'G-W784RHPQ98',
  );

}