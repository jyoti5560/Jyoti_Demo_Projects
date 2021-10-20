import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TabBar"),
      ),
      body: Column(
        children: [
          DefaultTabController(
            initialIndex: 1,
            length: 3,
            child: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              labelPadding: EdgeInsets.only(top: 10.0, bottom: 10),
              unselectedLabelColor: Colors.white,
              controller: _tabController,
              tabs: [
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4.0,
                            color: Colors.grey
                        )
                      ]
                  ),
                  child: Tab(
                    text: "A",
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4.0,
                            color: Colors.grey
                        )
                      ]
                  ),
                  child: Tab(
                    text: "B",
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4.0,
                            color: Colors.grey
                        )
                      ]
                  ),
                  child: Tab(
                    text: "C",
                  ),
                ),
              ],
            ),
          ),


          DefaultTabController(
            initialIndex: 1,
            length: 3,
            child: Container(
              height: MediaQuery.of(context).size.height /2,
              child: TabBarView(
                physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                dragStartBehavior: DragStartBehavior.start,
                controller: _tabController,
                children: [
                  Center(
                      child: Text(
                        'This is A Tab',
                        style: TextStyle(fontSize: 32, color: Colors.black),
                      )),
                  Center(
                      child: Text(
                        'This is B Tab',
                        style: TextStyle(fontSize: 32, color: Colors.black),
                      )),
                  Center(
                      child: Text(
                        'This is C Tab',
                        style: TextStyle(fontSize: 32, color: Colors.black),
                      )),
                ],
              ),
            ),
          ),


        ],
      )
    );
  }
}
