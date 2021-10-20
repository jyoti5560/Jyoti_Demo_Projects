import 'package:flutter/material.dart';
import 'package:untitled3/pages/about_screen.dart';
import 'package:untitled3/pages/cart_screen.dart';
import 'package:untitled3/pages/index_page.dart';
import 'package:untitled3/pages/message_screen.dart';
import 'package:untitled3/pages/notification_screen.dart';
import 'package:get/get.dart';
//import 'package:google_signin/pages/about_screen.dart';
//import 'package:google_signin/pages/cart_screen.dart';
//import 'package:google_signin/pages/index_page.dart';
//import 'package:google_signin/pages/message_screen.dart';
//import 'package:google_signin/pages/notification_screen.dart';

class BottomNavigation extends StatefulWidget {
  bool isDarkMode;
  final appdata;
  BottomNavigation({required this.isDarkMode, this.appdata});
  //const BottomNavigation({Key? key}) : super(key: key);

  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int menuIndex = 0;

  changeIndex(int index) {
    setState(() {
      menuIndex = index;
    });
  }

  Widget get getMenuByIndex {
    print("menuIndex -> " + menuIndex.toString());

    if (menuIndex == 0) {
      return IndexPage(isDarkMode: widget.isDarkMode, appdata: widget.appdata);
    } else if (menuIndex == 1) {
      return CartScreen();
    } else if (menuIndex == 2) {
      return MessageScreen();
    } else if (menuIndex == 3) {
      return NotificationScreen();
    }  else {
      return AboutScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: naviBar(context, changeIndex),
      body: Container(
        child: getMenuByIndex,
      ),
    );
  }

  Widget naviBar(BuildContext context, changeIndex) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      alignment: Alignment.center,
      color: Colors.green,
      /*decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
        color: Colors.green,
        boxShadow: [
          new BoxShadow(
            color: Colors.black38,
            blurRadius: 5,
          ),
        ],
      ),*/
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: () {
              changeIndex.call(0);
              setState(() {});
            },
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.all(5),
                    height: 30,
                    width: 30,
                    child: Icon(Icons.home),
                  ),
                  Text(
                    'home'.tr,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              changeIndex.call(1);
              setState(() {});
            },
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.all(5),
                    height: 30,
                    width: 30,
                    child: Icon(Icons.shopping_cart),
                  ),
                  Text(
                    'order'.tr,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              changeIndex.call(2);
              setState(() {});
            },
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(top: 5),
                    height: 30,
                    width: 30,
                    child: Icon(Icons.message),
                  ),
                  Text(
                    'messages'.tr,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              changeIndex.call(3);
              setState(() {});
            },
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.all(5),
                    height: 30,
                    width: 30,
                    child: Icon(Icons.dehaze),
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            onTap: () {
              changeIndex.call(4);
              setState(() {});
            },
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.all(5),
                    height: 30,
                    width: 30,
                    child: Icon(Icons.dehaze),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
