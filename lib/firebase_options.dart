import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions have only been configured for Android.',
      );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuCLumyKPPvXd4xAB8OAsev4obeyPp8w8',
    appId: '1:1014186503121:android:be31abddcd1df910b08ef0',
    messagingSenderId: '1014186503121',
    projectId: 'kaseapp-project',
    storageBucket: 'kaseapp-project.firebasestorage.app',
  );
  
}