
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAxO8luVZ50ubLg-vQMnplYEEObqM-HrB0',
    appId: '1:621426393684:web:a973fd89071408a6e123c1',
    messagingSenderId: '621426393684',
    projectId: 'pokeproyecto-793b5',
    authDomain: 'pokeproyecto-793b5.firebaseapp.com',
    storageBucket: 'pokeproyecto-793b5.firebasestorage.app',
    measurementId: 'G-YEPVFC94HS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6bOV-A3XTtyWftwVNGVNhUotg8tiCArA',
    appId: '1:621426393684:android:c3bc5e18c449b39de123c1',
    messagingSenderId: '621426393684',
    projectId: 'pokeproyecto-793b5',
    storageBucket: 'pokeproyecto-793b5.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAxO8luVZ50ubLg-vQMnplYEEObqM-HrB0',
    appId: '1:621426393684:web:e17c005f31566e59e123c1',
    messagingSenderId: '621426393684',
    projectId: 'pokeproyecto-793b5',
    authDomain: 'pokeproyecto-793b5.firebaseapp.com',
    storageBucket: 'pokeproyecto-793b5.firebasestorage.app',
    measurementId: 'G-6D5YRBCZK0',
  );
}
