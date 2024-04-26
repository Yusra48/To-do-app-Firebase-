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
    apiKey: 'AIzaSyD1MCACr0xlLKC2d5FbVQTD48b4JzB_4Y8',
    appId: '1:250990092473:web:2b8b0de4d9f9daf873bb68',
    messagingSenderId: '250990092473',
    projectId: 'to-do-app-firebase-85d48',
    authDomain: 'to-do-app-firebase-85d48.firebaseapp.com',
    storageBucket: 'to-do-app-firebase-85d48.appspot.com',
    measurementId: 'G-Q9TJNV90TT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNuWjdk2BfDXPYq7_avMcppyf1l6UyGrA',
    appId: '1:250990092473:android:b8057b413fa4923373bb68',
    messagingSenderId: '250990092473',
    projectId: 'to-do-app-firebase-85d48',
    storageBucket: 'to-do-app-firebase-85d48.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMQpWDFsrnn7gLjAPLx3ECo-mhdRtXUtI',
    appId: '1:250990092473:ios:5a7f7797316da5f973bb68',
    messagingSenderId: '250990092473',
    projectId: 'to-do-app-firebase-85d48',
    storageBucket: 'to-do-app-firebase-85d48.appspot.com',
    iosBundleId: 'com.example.application',
  );
}