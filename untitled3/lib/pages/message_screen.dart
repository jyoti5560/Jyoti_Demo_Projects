import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  MessageScreenState createState() => MessageScreenState();
}

class MessageScreenState extends State<MessageScreen> {
  final myController = TextEditingController();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late String firebaseToken;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.getToken().then((token){
      firebaseToken = token!;
      print(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width/2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    hintText: "Title",
                    border: InputBorder.none
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                PushNotification.sendNotification(
                   firebaseToken,
                   myController.text,
                   "Notification title",
                     1
                );
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey
                ),
                child: Center(
                  child: Text("Submit"),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

class PushNotification{
  static void sendNotification(
      String fcmToken,
      String body,
      String title,
      int type,
      ) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
        'key=AAAAQbvF4fI:APA91bEfq5SaG7sZJFbUXKcvlUskZadnPb3sBOWJbcM5zRzqTCbnSeqi9h0UsSRnbqMkzqrmVzOO10nW6Oy6flZUbursTsQzcxdKlxYvULlBfgevcZcqUI5pRPF7fYgcykrqxkRRvWab',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '$body',
            'title': '$title',
            'type': '$type'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '5',
            "sound": "default",
            'status': 'done'
          },
          'to': fcmToken,
        },
      ),

    );
    print(body);
   // print(response);
    if (response.statusCode == 200) {
// on success do
      print(response.body);
      print("Message Notification Sent to $fcmToken");
    } else {
// on failure do
    print(response.body);
      print("Message Notification Failed");
    }
  }
}
