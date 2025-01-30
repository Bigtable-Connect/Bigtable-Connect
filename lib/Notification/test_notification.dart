// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:bigtable_connect/Notification/server_key.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

Future<void> testNotification(
    {required String hospitalKey,
      required String disease,
      required String username,
      required String hospitalName,
      required String newDate}) async {


  var token;
  final userRef = FirebaseDatabase.instance
      .ref()
      .child("ArogyaSair/tblHospital")
      .child(hospitalKey);

  DatabaseEvent databaseEvent = await userRef.once();
  DataSnapshot dataSnapshot = databaseEvent.snapshot;

  var userData = dataSnapshot.value as Map;
  token = userData["HospitalFCMToken"];

  String constructFCMPayload(String token) {
    return jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body':
          "Appointment for $disease has been APPROVED by $username for $newDate date.",
          'title': "Appointment Notification",
        },
        'data': <String, dynamic>{
          'name': disease,
          'time': newDate.toString(),
          'status': username,
        },
        'to': token
      },
    );
  }

  if (token.isEmpty) {
    return log('Unable to send FCM message, no token exists.');
  }

  try {
    http.Response response =
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${ServerKey().serverKey}',
        },
        body: constructFCMPayload(token));

    log("status: ${response.statusCode} | Message Sent Successfully!");
  } catch (e) {
    log("error push notification $e");
  }
}
