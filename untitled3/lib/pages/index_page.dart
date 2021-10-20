import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:untitled3/app.dart';
import 'package:untitled3/common/custom_drawer.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';
//import 'package:google_signin/app.dart';
//import 'package:google_signin/common/custom_drawer.dart';

class IndexPage extends StatefulWidget {
  bool isDarkMode;
  final appdata;
  IndexPage({required this.isDarkMode, this.appdata});
  //const IndexPage({Key? key}) : super(key: key);

  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  List<String> images = [
    Images.ic_slider1,
    Images.ic_slider2,
    Images.ic_slider3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        /*actions: [
          IconButton(
              icon: Icon(Icons.lightbulb),
              onPressed: () {

              })
        ],*/
      ),
      drawer: Customdrawer(isDarkMode : widget.isDarkMode, appdata: widget.appdata),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 1)),
              width: MediaQuery.of(context).size.width,
              child: Swiper(
                autoplayDisableOnInteraction: true,
                autoplay: true,
                duration: 3000,
                loop: false,
                physics: BouncingScrollPhysics(),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Image.asset(images[index], fit: BoxFit.fill,);
                },
                pagination: SwiperPagination(
                  builder: new DotSwiperPaginationBuilder(
                      color: Colors.black,
                      activeColor: Colors.blue,
                      activeSize: 12,
                      size: 6),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
