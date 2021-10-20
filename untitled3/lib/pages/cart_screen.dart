import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> images = [
    "Flutter",
    "React native",
    "Codova/Phonegap",
    "Native script",
  ];

  @override
  Widget build(BuildContext context) {

    return BackdropScaffold(
      appBar: BackdropAppBar(
        title: Text("Cart"),
        /*actions: <Widget>[
          BackdropToggleButton(
            icon: AnimatedIcons.list_view,
          )
        ],*/
      ),
      backLayer: Center(
        child: Text("Back Layer"),
      ),
      frontLayer: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(
            Duration(seconds: 1),
                () {
              setState(() {
                images.addAll(["Ionic", "Xamarin"]);
              });

              _scaffoldKey.currentState!.showSnackBar(
                SnackBar(
                  content: const Text('Page Refreshed'),
                ),
              );
            },
          );
        },
        child: ListView.builder(
          itemCount: images.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (ctx, idx) {
            // List Item
            return Card(
              child: ListTile(
                title: Text(images[idx]),
              ),
            );
          },

        ),

      ),

    );
  }
}
