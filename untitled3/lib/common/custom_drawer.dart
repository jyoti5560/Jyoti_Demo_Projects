//import 'package:demo_project/collection_screen/collection_screen.dart';
//import 'package:demo_project/settings/settings_screen.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_configuration/global_configuration.dart';
//import 'package:google_signin/common/custom_trace.dart';
//import 'package:google_signin/common/l10n.dart';
//import 'package:google_signin/models/setting.dart';
//import 'package:google_signin/pages/background_tracking.dart';
//import 'package:google_signin/pages/charts.dart';
//import 'package:google_signin/pages/digital_signature.dart';
//import 'package:google_signin/pages/music_player.dart';
//import 'package:google_signin/pages/payment.dart';
//import 'package:google_signin/pages/pdf_viewer.dart';
//import 'package:google_signin/pages/search_functionality.dart';
//import 'package:google_signin/pages/timer_break_module.dart';
//import 'package:google_signin/pages/youtube_video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/models/setting.dart';
import 'package:untitled3/pages/background_tracking.dart';
import 'package:untitled3/pages/charts.dart';
import 'package:untitled3/pages/currency.dart';
import 'package:untitled3/pages/digital_signature.dart';
import 'package:untitled3/pages/multiple_language/multiple_languages.dart';
import 'package:untitled3/pages/music_player.dart';
import 'package:untitled3/pages/pagination.dart';
import 'package:untitled3/pages/payment.dart';
import 'package:untitled3/pages/pdf_viewer.dart';
import 'package:untitled3/pages/search_functionality.dart';
import 'package:untitled3/pages/timer_break_module.dart';
import 'package:untitled3/pages/youtube_video_player.dart';

import 'custom_trace.dart';

class Customdrawer extends StatefulWidget {
  //const Customdrawer({Key? key}) : super(key: key);
  //Function(int) callBack;
  bool isDarkMode;
  final appdata;
  Customdrawer({required this.isDarkMode, this.appdata});

 // Customdrawer({required this.callBack});
  @override
  CustomdrawerState createState() => CustomdrawerState();
}

class CustomdrawerState extends State<Customdrawer> {

   File? _image;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //SizedBox(height: 40,),
        Expanded(
          child: drawerBody(),
        )
      ],
    );
  }

  logout(){
    return Container(
      child: Row(
        children: [
          Container(
            child: Icon(Icons.logout, color: Colors.white,),
          ),
          Container(
              child: Text("Logout", style: TextStyle(color: Colors.white),)
          )
        ],
      ),
    );
  }

  drawerBody(){
    return Container(
      width: MediaQuery.of(context).size.width/1.5,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),

      child: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            close(),
            profile(),
            //FlutterLogo(size: 60,),
            SizedBox(height: 10,),
            Container(height: 5, color: Colors.black,),
            SizedBox(height: 10,),
            drawerList(),
          ],
        ),
      ),
    );
  }

  close(){
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Container(
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(right: 10, top: 10),
        child: Icon(Icons.close, color: Colors.white, size: 20,),
      ),
    );
  }

  profile(){
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            _image != null ?
            ClipRRect(
              borderRadius: BorderRadius.circular(80.0),
              child: Image.file(_image!, height: 100 ,width: 100, fit: BoxFit.fill ),
            )
            :
            ClipRRect(
              borderRadius: BorderRadius.circular(80.0),
              child: Container(
                color: Colors.white,
                  height: 100 ,width: 100,
                child: FlutterLogo(),
              ),
            ),
            /*ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.file(
                _image!,
                width: 50,
                height: 50,
                fit: BoxFit.fitHeight,
              ),
            ):
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30)),
              width: 80,
              height: 80,
              child: Icon(
                Icons.camera_alt,
                color: Colors.grey[800],
              ),
            ),*/
            GestureDetector(
              onTap: (){
                _showPicker(context);
              },
              child: Container(
                height: 25, width: 25,
                margin: EdgeInsets.only(top: 10),
                //alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.indigo
                ),
                child: Icon(Icons.camera_alt),
              ),
            ),
          ],

        ),
        SizedBox(height: 10,),
        Container(
          child: Text('jenny'.tr, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 5,),
        Container(
          child: Text("jenny123@demo.com", style: TextStyle(color: Colors.white, fontSize: 15),),
        )
      ],
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = File(image!.path);
    });
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    var image = await  _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = File(image!.path);
    });
  }

  drawerList(){
    return Column(
      children: [
        DrawerItem(
          title: 'Home',
          leadingWidget: Icon(Icons.home, color: Colors.white,),
          callback: (){
            //widget?.callBack?.call(2);
            //Navigator.pop(context);
          },
        ),

        DrawerItem(
          title: 'Charts',
          leadingWidget: Icon(Icons.person, color: Colors.white,),
          callback: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Charts()),
            );
            //widget?.callBack?.call(0);
            //Navigator.pop(context);
          },
        ),
        DrawerItem(
          title: 'Pdf Viewer',
          leadingWidget: Icon(Icons.person, color: Colors.white,),
          callback: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PdfViewer()),
            );
            // widget?.callBack?.call(2);
            // Navigator.pop(context);
          },
        ),
        DrawerItem(
          title: 'Timer Break module',
          leadingWidget: Icon(Icons.notifications, color: Colors.white,),
          callback: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TimerBreakModule()),
            );
            //widget?.callBack?.call(1);
            // Navigator.pop(context);
          },
        ),
        DrawerItem(
          title: 'Digital signature',
          leadingWidget: Icon(Icons.settings_rounded, color: Colors.white,),
          callback: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DigitalSignature()),
            );
            // widget?.callBack?.call(2);
            // Navigator.pop(context);
          },
        ),
        DrawerItem(
          title: 'Background Tracking',
          leadingWidget: Icon(Icons.contact_page, color: Colors.white,),
          callback: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BackGroundTracking()),
            );
            //widget?.callBack?.call(1);
            // Navigator.pop(context);
          },
        ),
        DrawerItem(
          title: 'Search',
          leadingWidget: Icon(Icons.contact_page, color: Colors.white,),
          callback: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Search()),
            );
            //widget?.callBack?.call(1);
            // Navigator.pop(context);
          },
        ),
        DrawerItem(
          title: 'Payment',
          leadingWidget: Icon(Icons.contact_page, color: Colors.white,),
          callback: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Payment()),
            );
            //widget?.callBack?.call(1);
            // Navigator.pop(context);
          },
        ),
        DrawerItem(
          title: 'Youtube video Player',
          leadingWidget: Icon(Icons.contact_page, color: Colors.white,),
          callback: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => YouTubeVideoPlayer()),
            );
            //widget?.callBack?.call(1);
            // Navigator.pop(context);
          },
        ),
        DrawerItem(
          title: 'Music Player',
          leadingWidget: Icon(Icons.contact_page, color: Colors.white,),
          callback: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MusicPlayer()),
            );
            //widget?.callBack?.call(1);
            // Navigator.pop(context);
          },
        ),
        /*DrawerItem(
          title:Theme.of(context).brightness == Brightness.dark ? lightMode : darkMode,
          leadingWidget: Icon(Icons.contact_page, color: Colors.white,),
          callback: (){
            if (Theme.of(context).brightness == Brightness.dark) {
              print("dark");
              setBrightness(Brightness.light);
              setting.value.brightness.value = Brightness.light;
            } else {
              print("light");
              setBrightness(Brightness.dark);
              setting.value.brightness.value = Brightness.dark;

            }
            setting.notifyListeners();
            //widget?.callBack?.call(1);
             //Navigator.pop(context);
          },
        ),*/
       /* DrawerItem(
          title: Theme.of(context).brightness == Brightness.dark ? lightMode : darkMode,
          leadingWidget: Icon(Icons.brightness_6, color: Colors.white),
          callback: (){
            Get.isDarkMode
                ? Get.changeTheme(ThemeData.light())
                : Get.changeTheme(ThemeData.dark());
            //widget?.callBack?.call(1);
            // Navigator.pop(context);
          },
        ),*/
        Container(
          margin: EdgeInsets.only(left: 10, top: 20, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.brightness_6, color: Colors.white),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(Theme.of(context).brightness == Brightness.dark ? lightMode : darkMode,
                        style: TextStyle(color: Colors.white),)),
                ],
              ),


              Switch(
                  value: widget.isDarkMode ,
                  onChanged: (value) {
                    print(value);
                    print(widget.isDarkMode);
                    widget.appdata.write('darkmode', value);
                  }
              ),
            ],
          ),
        ),

        DrawerItem(
          title: "Currency",
          leadingWidget: Icon(Icons.brightness_6, color: Colors.white),
          callback: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CurrencyPage()),
            );
            //widget?.callBack?.call(1);
            // Navigator.pop(context);
          },
        ),

        DrawerItem(
          title: "Languages",
          leadingWidget: Icon(Icons.brightness_6, color: Colors.white),
          callback: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MultipleLanguages()),
            );
            //widget?.callBack?.call(1);
            // Navigator.pop(context);
          },
        ),

        DrawerItem(
          title: "Pagination",
          leadingWidget: Icon(Icons.brightness_6, color: Colors.white),
          callback: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Pagination()),
            );
            //widget?.callBack?.call(1);
            // Navigator.pop(context);
          },
        ),

        DrawerItem(
          title: 'Logout',
          leadingWidget: Icon(Icons.logout, color: Colors.white,),
          callback: (){
            //widget?.callBack?.call(1);
            // Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

String get lightMode {
  return Intl.message(
    'Light Mode',
    name: 'light_mode',
    desc: '',
    args: [],
  );
}

String get darkMode {
  return Intl.message(
    'Dark Mode',
    name: 'dark_mode',
    desc: '',
    args: [],
  );
}

void setBrightness(Brightness brightness) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (brightness == Brightness.dark) {
    prefs.setBool("isDark", true);
    brightness = Brightness.dark;
  } else {
    prefs.setBool("isDark", false);
    brightness = Brightness.light;
  }
}
ValueNotifier<Setting> setting = new ValueNotifier(new Setting());
Future<Setting> initSettings() async {
  Setting _setting;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}settings';
  try {
    final response = await http.get(Uri.parse(url), headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200 && response.headers.containsValue('application/json')) {
      if (json.decode(response.body)['data'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('settings', json.encode(json.decode(response.body)['data']));
        _setting = Setting.fromJSON(json.decode(response.body)['data']);
        /*if (prefs.containsKey('language')) {
          _setting.mobileLanguage.value = Locale(prefs.get('language'), '');
        }*/
        _setting.brightness.value = prefs.getBool('isDark') ?? false ? Brightness.dark : Brightness.light;
        setting.value = _setting;
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        setting.notifyListeners();
      }
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Setting.fromJSON({});
  }
  return setting.value;
}

class DrawerItem extends StatelessWidget {
  final VoidCallback callback;
  final String title;
  final Widget leadingWidget;

  DrawerItem({required this.callback, required this.title, required this.leadingWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: callback,
        child: Container(
          margin: EdgeInsets.only(left: 10, top: 20),
          child: Row(
            children: [
              Container(

                //height: MediaQuery.of(context).size.height * 0.06,
                //width: MediaQuery.of(context).size.height * 0.06,
                alignment: Alignment.center,
                child: leadingWidget,
              ),
              SizedBox(width: 10,),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
}
