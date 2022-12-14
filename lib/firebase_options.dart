import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCdUrsQ-p4DWZP-I6HLhbs7Bw6Vz8xnv68',
    appId: '1:589988597380:web:3aa3531dd5efcda2af7cd1',
    messagingSenderId: '589988597380',
    projectId: 'hsb-bar',
    authDomain: 'hsb-bar.firebaseapp.com',
    storageBucket: 'hsb-bar.appspot.com',
    measurementId: 'G-P8QKYGT16T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQ1pgX7EEjdgrbTfL4FeWARkFfUNSuRro',
    appId: '1:589988597380:android:14fd0f3d3d60a65baf7cd1',
    messagingSenderId: '589988597380',
    projectId: 'hsb-bar',
    storageBucket: 'hsb-bar.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCitR-sJAD2VA10qCHCfOVNMdo8lNnX6uY',
    appId: '1:589988597380:ios:53606ec5e9dadd2aaf7cd1',
    messagingSenderId: '589988597380',
    projectId: 'hsb-bar',
    storageBucket: 'hsb-bar.appspot.com',
    iosClientId: '589988597380-83i9jlnabjhje6pisjgdpcl0uh705rvk.apps.googleusercontent.com',
    iosBundleId: 'com.example.barCommande',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCitR-sJAD2VA10qCHCfOVNMdo8lNnX6uY',
    appId: '1:589988597380:ios:53606ec5e9dadd2aaf7cd1',
    messagingSenderId: '589988597380',
    projectId: 'hsb-bar',
    storageBucket: 'hsb-bar.appspot.com',
    iosClientId: '589988597380-83i9jlnabjhje6pisjgdpcl0uh705rvk.apps.googleusercontent.com',
    iosBundleId: 'com.example.barCommande',
  );
}
