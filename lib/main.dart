// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, non_constant_identifier_names

import 'package:bigtable_connect/Auth/Login.dart';
import 'package:bigtable_connect/screens/home_screen.dart';
import 'package:bigtable_connect/secondFirebaseInitialization.dart';
import 'package:bigtable_connect/services/notification_service.dart';
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
  await InitializeSecondProject.initializeSecondProject();
  await Firebase.initializeApp();
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
  final key1 = "Email";
  late bool contains;
  late String keyToCheck;
  var page;
  late String? fcmToken = "";
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool i = false;
  bool loginChecked = false;
  final _messagingService = MessagingService();

  @override
  void initState() {
    super.initState();
    _messagingService.init(context);
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // BuildContext Context = context;

    // If not the first time, proceed directly
    await Future.delayed(const Duration(seconds: 5));
    fcmToken = await _fcm.getToken();
    await _checkIfLoggedIn();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  bool isLoginProcessRunning = false; // Prevent multiple login checks

  Future<void> _checkIfLoggedIn() async {
    if (isLoginProcessRunning) return; // Avoid multiple calls
    isLoginProcessRunning = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    contains = prefs.containsKey(key1);

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (contains) {
        var email = await getData("Email");
        Query dbRef2 = FirebaseDatabase.instance
            .ref()
            .child('BigtableConnect/tblUser')
            .orderByChild("Email")
            .equalTo(email);

        await dbRef2.once().then((documentSnapshot) async {
          for (var x in documentSnapshot.snapshot.children) {
            String? key = x.key;
            Map data = x.value as Map;
            String? FCMToken = data["FCMToken"];

            if (FCMToken == fcmToken) {
              await saveStudentData(data, key);
              page = const HomeScreen(); // Student Page
            } else if (FCMToken == "") {
              await saveStudentData(data, key);
              await updateFCMToken(key!, fcmToken!);
              page = const HomeScreen();
            } else {
              await clearPreferences(); // Clear preferences
              await updateFCMToken(key!, "");
              page = const LoginPage(); // Redirect to App
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

  Future<void> saveStudentData(Map data, String? key) async {
    await saveData('FirstName', data["FirstName"]);
    await saveData('LastName', data["LastName"]);
    await saveData('Email', data["Email"]);
    await saveData('key', key);
  }

  Future<void> updateFCMToken(String key, String FcmToken) async {
    final updatedData = {"FCMToken": FcmToken};
    final userRef = FirebaseDatabase.instance
        .ref()
        .child("BigtableConnect/tblUser")
        .child(key);
    await userRef.update(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF113826),
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
