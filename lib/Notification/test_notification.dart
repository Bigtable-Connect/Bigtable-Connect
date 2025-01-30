// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

Future<void> testNotification(
    {required String hospitalKey,
      required String disease,
      required String username,
      required String hospitalName,
      required String newDate}) async {
  var serverKey =
      'ya29.c.c0ASRK0GZZhy1HjXb4iICNyXhgY5pWOndGyRXNLslpazl1107njCTdY9Dz0lSx5uRM60OII2Wo1_OBymeXpGytEHK-vNnwk0sMFijatuN-8qxjnZux0l_6Z1vp8hBaOfcXGQlpS19fsg3bPEjYooAoVsFEzAEMN0wf7ewjlFK500RV7WeKGoPsCy0smabx4N6yk-bJJncVmkEVlN9CoBT1v6yI8fd3c3i2CbPRkQ8fpsa7hZJYrq-8WtVDfgPn2WRw5lG1ct8DkGNW6SYUW8BDFFzuv1xfSLicCRQvcR5ebROgVesgCnqQ6-gzsGs9vP0RukZpZL049T6V9vb5rD_ZA7vaT9uVEvxe8KGxzWFnUz-hKiaqRArAo_DTARMFH389CFBld7M-dzVurjmfet69x38o482xtlOMn_nuJ7d8m96BZqcbm_I26WuOYb96b7trlvjxop4s38ps24sawqp2tat_QVl73si0Vnu44nWfpwrde2bw5rVMYRdVt93OyYWbeRfBsiYy__tI-MaxuJgxkqZziv6z738vhxpWkW11IvgJp18ckwx0UUf4YViJqVhZlMvYR3h4xO2gy27p7Su-6WW49qsb9US30-56p5fprg1y8r5gviIWxR4udqWXg2J8gV9ROc985zk3JYMnyWo39Y32xIpdgosv__XpoMO8XI6ZV08Wto8v2wnW8rsawjOdomZYgmbvYqu7FcRpdg463U7j4tkSc7FkbgQB7RiIkzyrIodhFpMwvxsk-34-ZOMeBSIrk7wcYq39e5BZ565vq08hex2Og67q1wsmQMx56_xF9yUaYIxjd6IXecf4ixOa1VawejVZ4gpr9Os_7WMMwkUnFhnVz7t-OJSMpk5Oj9JUZ7YR7eOUhJk35cMui8VvaaihsnkkUeIthn5sdv7jsy5ec7k9eo3aMMvprciOmdj-z5fUc-a-yM21IvyiM4j2nsBtuk3Ybwk7wB9kRl0X6mOSkiUFRjt_JgyydoMxkjy_OybjVS4lh0V';

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
          'Authorization': 'key=$serverKey',
        },
        body: constructFCMPayload(token));

    log("status: ${response.statusCode} | Message Sent Successfully!");
  } catch (e) {
    log("error push notification $e");
  }
}
