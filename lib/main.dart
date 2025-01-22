import 'package:bigtable_connect/Auth/Login.dart';
import 'package:bigtable_connect/secondFirebaseInitialization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Auth/SharedPreferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Initialize the primary Firebase app
  await Firebase.initializeApp();
  await InitializeSecondProject.initializeSecondProject();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String data = "";
  final key = 'AdminEmail';
  final key1 = 'Email';
  late bool adminContains;
  late bool studentContains;
  late String keyToCheck;
  var page;
  late String? fcmToken = "";
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool i = false;
  bool loginChecked = false;

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var firstTime = prefs.containsKey("firstTime");
    BuildContext Context = context;

    if (!firstTime) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Here\'s a message for you from the admin...!!'),
            content: const Text(
                "You have to make a payment before logging in. To know the details of the packages and the price, please contact the admin at this email address: programmerprodigies@gmail.com."),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  // await saveFirstTime(true);
                  await Future.delayed(const Duration(seconds: 5));
                  fcmToken = await _fcm.getToken();
                  await _checkIfLoggedIn();
                  Navigator.pushReplacement(
                    Context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    } else {
      // If not the first time, proceed directly
      await Future.delayed(const Duration(seconds: 5));
      fcmToken = await _fcm.getToken();
      await _checkIfLoggedIn();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  bool isLoginProcessRunning = false; // Prevent multiple login checks

  Future<void> _checkIfLoggedIn() async {
    if (isLoginProcessRunning) return; // Avoid multiple calls
    isLoginProcessRunning = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    adminContains = prefs.containsKey(key);
    studentContains = prefs.containsKey(key1);

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (adminContains) {
        page = const LoginPage(); // Admin Page
      } else if (studentContains) {
        var email = await getData("Email");
        Query dbRef2 = FirebaseDatabase.instance
            .ref()
            .child('pp_test_mode/tblStudent')
            .orderByChild("Email")
            .equalTo(email);

        await dbRef2.once().then((documentSnapshot) async {
          for (var x in documentSnapshot.snapshot.children) {
            String? key = x.key;
            Map data = x.value as Map;
            String? FCMToken = data["FCMToken"];
            String semester = data["Semester"];

            // Get semester data
            Query dbRef = FirebaseDatabase.instance
                .ref()
                .child('pp_test_mode/tblSemester')
                .child(semester);

            DatabaseEvent databaseEventStudent = await dbRef.once();
            Map semData = databaseEventStudent.snapshot.value as Map;

            if (semData["Visibility"] == "true") {
              if (FCMToken == fcmToken) {
                await saveStudentData(data, key, semData);
                page = const LoginPage(); // Student Page
              } else if (FCMToken == "") {
                await saveStudentData(data, key, semData);
                await updateFCMToken(key!, fcmToken!);
                page = const LoginPage();
              } else {
                await clearPreferences(); // Clear preferences
                await updateFCMToken(key!, "");
                page = const MyApp(); // Redirect to App
              }
            } else {
              page = const LoginPage(); // Login page if semester not visible
            }
          }
        });
      } else {
        page = const LoginPage(); // Default Login Page
      }
    } else {
      page = const LoginPage(); // If no user is logged in
    }

    isLoginProcessRunning = false; // Reset flag
    loginChecked = true; // Mark login check completed
  }

  Future<void> clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all preferences
    // await saveFirstTime(true);
  }

  Future<void> saveStudentData(Map data, String? key, Map semData) async {
    await saveData('FirstName', data["FirstName"]);
    await saveData('LastName', data["LastName"]);
    await saveData('Semester', data["Semester"]);
    await saveData('SemesterName', semData["Semester"]);
    await saveData('Email', data["Email"]);
    await saveData('Theory', data["Theory"].toString());
    await saveData('Practical', data["Practical"].toString());
    await saveData('Papers', data["Papers"].toString());
    await saveData('Demo', data["Demo"].toString());
    await saveData('key', key);
  }

  Future<void> updateFCMToken(String key, String FcmToken) async {
    final updatedData = {"FCMToken": FcmToken};
    final userRef = FirebaseDatabase.instance
        .ref()
        .child("pp_test_mode/tblStudent")
        .child(key);
    await userRef.update(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2a446b),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/Logo/Bigtable.gif"),
          ],
        ),
      ),
    );
  }
}
