// Initialize the secondary Firebase app
import 'package:firebase_core/firebase_core.dart';

class InitializeSecondProject {
  static FirebaseApp? secondaryApp;
  static Future<void> initializeSecondProject() async {
    secondaryApp = await Firebase.initializeApp(
      name: 'SecondaryApp',
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDxt2_HAugXvbs-25Lyqf00Qc7J2LMucL0',
        appId: '1:586592318920:android:75285b5ac0dbce88c53cfd',
        messagingSenderId: '586592318920',
        projectId: 'arogyasair-b7bb5',
        databaseURL: 'https://arogyasair-b7bb5-default-rtdb.firebaseio.com',
        storageBucket: 'arogyasair-b7bb5.appspot.com',
      ),
    );
  }
}
