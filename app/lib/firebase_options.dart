// Fichier généré à partir de google-services.json (projet running-club-tunis).
// Android configuré ; autres plateformes : exécutez "flutterfire configure" si besoin.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzkLEM077SIiTQarTUf5EaW6TxfvptRt4',
    appId: '1:228140996296:android:7b612f56967d199a39f7fd',
    messagingSenderId: '228140996296',
    projectId: 'running-club-tunis',
    storageBucket: 'running-club-tunis.firebasestorage.app',
  );

  // iOS / macOS / web / windows : non enregistrés dans ce google-services.json.
  // Pour les activer : Firebase Console → ajouter les apps, puis flutterfire configure.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'ios-key-not-configured',
    appId: 'ios-app-not-configured',
    messagingSenderId: '228140996296',
    projectId: 'running-club-tunis',
    storageBucket: 'running-club-tunis.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'macos-key-not-configured',
    appId: 'macos-app-not-configured',
    messagingSenderId: '228140996296',
    projectId: 'running-club-tunis',
    storageBucket: 'running-club-tunis.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'windows-key-not-configured',
    appId: 'windows-app-not-configured',
    messagingSenderId: '228140996296',
    projectId: 'running-club-tunis',
    storageBucket: 'running-club-tunis.firebasestorage.app',
  );
}
