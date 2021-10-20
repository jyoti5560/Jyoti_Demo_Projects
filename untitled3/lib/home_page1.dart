import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled3/models/user.dart';
//import 'package:google_signin/constants.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:google_signin/models/user.dart';
/*import 'package:linkedin_login/constants.dart';
import 'package:linkedin_login/models/user.dart';*/

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  late User user;

  @override
  void initState() {
  //  fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: user != null
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              appBar(),
              SizedBox(
                height: 30,
              ),
              Text(
                'Hello, ${user.firstName}!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          )
              : Container(),
        ),
      ),
    );
  }

  /*void fetchUser() async {
    final storage = FlutterSecureStorage();
    final map = json.decode(await storage.read(key: Constants.user));
    setState(() {
      user = User.fromJson(map);
    });
  }*/

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // FaIcon(
        //   FontAwesomeIcons.linkedinIn,
        //   color: Colors.blue[900],
        //   size: 30,
        // ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: Image.network(
                    user.profileImage,
                    height: 50,
                    width: 50,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35),
                  width: 13,
                  height: 13,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      color: Colors.green[300],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Image.asset(
              'assets/images/menu.png',
              width: 30,
              height: 30,
            )
          ],
        )
      ],
    );
  }
}
