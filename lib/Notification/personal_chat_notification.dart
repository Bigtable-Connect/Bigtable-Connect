// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:bigtable_connect/Notification/server_key.dart';
import 'package:http/http.dart' as http;

personalChatNotification(
    {required String fcmToken, required String name}) async {
  var serverKey = ServerKey().serverKey;

  String constructFCMPayload(String token) {
    return jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': "You got new message from $name",
          'title': "New Notification",
        },
        'data': <String, dynamic>{
          'name': name,
          'time': DateTime.now().toString(),
        },
        'to': token
      },
    );
  }

  try {
    http.Response response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverKey',
            },
            body: constructFCMPayload(fcmToken));

    log("status: ${response.statusCode} | Message Sent Successfully!");
  } catch (e) {
    log("error push notification $e");
  }
}
