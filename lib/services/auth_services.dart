// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:bigtable_connect/Auth/Login.dart';
import 'package:bigtable_connect/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/SharedPreferences.dart';
import '../Model/registration_mode.dart';

class AuthService {
  late Query dbRef2;

  Future<void> signUp(
      {required String firstName,
      required String lastName,
      required String email,
      required String password,
      required String contact,
      required String gender,
      required String fcmToken,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      DatabaseReference dbRefTblUser =
          FirebaseDatabase.instance.ref().child('BigtableConnect/tblUser');

      RegistrationModel regobj = RegistrationModel(
        firstName,
        lastName,
        email,
        contact,
        gender,
        fcmToken,
      );
      dbRefTblUser.push().set(regobj.toJson());
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'weak-password') {
        message = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        message = "An account already exists with the email.";
      }
      if (kDebugMode) {
        print(message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> signIn(
      {required String email,
      required String password,
      required BuildContext context,
      required String FcmToken}) async {
    print(email);
    print(password);
    print(context);
    print(FcmToken);
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (email == "programmerprodigies@gmail.com") {
        dbRef2 = FirebaseDatabase.instance
            .ref()
            .child('BigtableConnect/tblUser')
            .orderByChild("Email")
            .equalTo(email);
        Map data;
        await dbRef2.once().then((documentSnapshot) async {
          for (var x in documentSnapshot.snapshot.children) {
            String? key = x.key;
            data = x.value as Map;
            if (data["Email"] == email) {
              await saveData('email', data["Email"]);
              await saveKey(key);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            }
          }
        });
        await saveData("AdminEmail", email);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (scaffoldContext) => const LoginPage()));
      } else {
        dbRef2 = FirebaseDatabase.instance
            .ref()
            .child('BigtableConnect/tblUser')
            .orderByChild("Email")
            .equalTo(email);
        String msg = "Invalid email or Password..!";
        Map data;
        await dbRef2.once().then((documentSnapshot) async {
          for (var x in documentSnapshot.snapshot.children) {
            String? key = x.key;
            data = x.value as Map;
            String? FCMToken = data["FCMToken"];
            var firstName = data["FirstName"];
            var lastName = data["LastName"];
            var email = data["Email"];
            if (FCMToken == "") {
              final updatedData = {"FCMToken": FcmToken};
              final userRef = FirebaseDatabase.instance
                  .ref()
                  .child("BigtableConnect/tblUser")
                  .child(key!);
              await userRef.update(updatedData);
              if (data["Email"] == email) {
                await saveData('FirstName', firstName);
                await saveData('LastName', lastName);
                await saveData('Email', email);
                await saveKey(key);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              } else {
                msg = "Sorry..! Wrong email or Password";
                _showSnackbar(context, msg);
              }
            } else if (FCMToken == FcmToken) {
              if (data["Email"] == email) {
                await saveData('FirstName', firstName);
                await saveData('LastName', lastName);
                await saveData('Email', email);
                await saveKey(key);
                // await saveData('key', key);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              } else {
                msg = "Sorry..! Wrong email or Password";
                _showSnackbar(context, msg);
              }
            } else if (FCMToken != FcmToken) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Login..!!'),
                    content: const Text(
                        "You already have logged in some other device, Do you want to continue with this device ?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final updatedData = {"FCMToken": FcmToken};
                          final userRef = FirebaseDatabase.instance
                              .ref()
                              .child("BigtableConnect/tblUser")
                              .child(key!);
                          await userRef.update(updatedData);
                          await saveData('FirstName', firstName);
                          await saveData('LastName', lastName);
                          await saveData('Email', email);
                          await saveKey(key);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("FirstName");
              prefs.remove("LastName");
              prefs.remove("Email");
              prefs.remove("key");
            }
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'user-not-found') {
        message = "The password provided is too weak.";
      } else if (e.code == 'wrong-password') {
        message = "An account already exists with the email.";
      } else if (e.code == "invalid-credential") {
        message = "Wrong id or password.\nPlease try to change the password.";
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Alert Message"),
              content: Text(message),
              actions: <Widget>[
                OutlinedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
          barrierDismissible: false);
      if (kDebugMode) {
        print(message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> signOut({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut();
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
