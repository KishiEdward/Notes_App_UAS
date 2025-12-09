import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyACrsdVPkpOhM-_Erz1OAMK7KsUSFHyUq0',
    appId: '1:946773463382:web:37b22a0a112ec84ff1c6f7', 
    messagingSenderId: '946773463382',
    projectId: 'notesapp-b88a3',
    authDomain: 'notesapp-b88a3.firebaseapp.com',
    storageBucket: 'notesapp-b88a3.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACrsdVPkpOhM-_Erz1OAMK7KsUSFHyUq0',
    appId: '1:946773463382:android:d2a0ea5ece0a9d06f1c6f7',
    messagingSenderId: '946773463382',
    projectId: 'notesapp-b88a3',
    storageBucket: 'notesapp-b88a3.firebasestorage.app',
  );
}
