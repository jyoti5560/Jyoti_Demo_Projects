
import 'dart:async';
import 'dart:convert' show json, jsonDecode;
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
//import 'package:google_signin/constants.dart';
//import 'package:google_signin/home_page.dart';
//import 'package:google_signin/home_page1.dart';
//import 'package:google_signin/linkedin_page.dart';
//import 'package:google_signin/linkedin_web_login.dart';
//import 'package:google_signin/pages/bottom_navigation.dart';
//import 'package:google_signin/sign_in_with_google.dart';
//import 'package:google_signin/util.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:untitled3/constants.dart';
import 'package:untitled3/home_page.dart';
import 'package:untitled3/home_page1.dart';
import 'package:untitled3/linkedin_web_login.dart';
import 'package:untitled3/pages/bottom_navigation.dart';
import 'package:untitled3/pages/index_page.dart';
import 'package:untitled3/pages/multiple_language/localization_service.dart';
import 'package:untitled3/sign_in_with_google.dart';
//import 'package:share/share.dart';

import 'common/custom_drawer.dart' as settingRepo;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
   clientId: '282323182066-83t8mblppmosnmk1oq0sfmo9m2hkpvl0.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);


Future<void> main() async{
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
    //  'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(
    MaterialApp(
      title: 'Google Sign In',
      home: MyApp(),
    ),
  );
  secureScreen();
}


class MyApp extends StatelessWidget {
  final appdata = GetStorage();
  @override
  Widget build(BuildContext context) {
    appdata.writeIfNull('darkmode', false);
    return SimpleBuilder(
      builder: (_){
        bool isDarkMode = appdata.read('darkmode');
        return GetMaterialApp(
          theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          // Remove the debug banner
          debugShowCheckedModeBanner: false,
          title: 'Kindacode.com',
         // darkTheme: ThemeData.dark(),
          //themeMode: ThemeMode.system,
          locale: LocalizationService.locale,
          fallbackLocale: LocalizationService.fallbackLocale,
          translations: LocalizationService(),
          // Theme mode depends on device settings at the beginning
          home: SignInDemo(isDarkMode: isDarkMode, appdata: appdata),
        );
      },
    );
  }
}

Future<void> secureScreen() async {
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}

class SignInDemo extends StatefulWidget {
  final FacebookLogin  plugin = FacebookLogin(debug: true);
  bool isDarkMode;
  final appdata;

  SignInDemo({required this.isDarkMode, this.appdata});
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late String firebaseToken;
  Connectivity connectivity = Connectivity();

  GoogleSignInAccount? _currentUser;
  String _contactText = '';
  //FacebookLogin fbAuthManager = FacebookLogin();
  final plugin = FacebookLogin(debug: true);
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';
  String email = '';
  String password = '';
  FocusNode? myFocusNode;
  FocusNode? myFocusNode2;
  bool agree = false;

  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _imageUrl;
  String? _email;
  String? _sdkVersion;
  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  var _logInformKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _checkBio();
    _firebaseMessaging.getToken().then((token){
      //firebaseToken = token!;
      print("token===$token");
    });
    myFocusNode = FocusNode();
    myFocusNode2 = FocusNode();
    settingRepo.initSettings();
    verifyLogin();
    //_getSdkVersion();
    _updateLoginInfo();
    /*_googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {

        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();*/

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        /*Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true));*/
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                //channel!.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      /* Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));*/
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode!.dispose();

    super.dispose();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'];
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      print("=====");
      //print("current user===${_googleSignIn.currentUser!.email}");
      _googleSignIn.signOut();
      await _googleSignIn.signIn();
    } catch (error) {
      print("======================");
      print(error);
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title'
    );
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    final isLogin = _token != null && _profile != null;
    GoogleSignInAccount? user = _currentUser;

      return Form(
        key: _logInformKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //const Text("You are not currently signed in."),
            /*ElevatedButton(
              child: const Text('SIGN IN'),
              onPressed: _handleSignIn,
            ),*/

            Container(
              height: 40,
              width: MediaQuery.of(context).size.width/1.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200
              ),
              child: TextFormField(
                controller: loginEmailController,
                focusNode: myFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email)
                ),
                /*onChanged: (String value) => setState(() {
                  email = value;
                }),*/
                onSaved: (String? val) {
                  email = val!;
                },
                validator: validateEmail,
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width/1.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.shade200
              ),
              child: TextFormField(
                controller: loginPasswordController,
                focusNode: myFocusNode2,
                autofocus: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    prefixIcon: Icon(Icons.password)
                ),
               /* onChanged: (String value) => setState(() {
                  password = value;
                }),*/
                onSaved: (String ?val) {
                  password = val!;
                },
                validator: validatePassword,
              ),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Material(
                  child: Checkbox(
                    value: agree,
                    onChanged: (value) {
                      setState(() {
                        agree = value ?? false;
                      });
                    },
                  ),
                ),
                Text(
                  'I have read and accept terms and conditions',
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            SizedBox(height: 20,),

            GestureDetector(
              onTap: (){
                agree ? navigate(): null;
                //networkConnection();
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavigation()),
                  );*/

                  },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green
                ),
                child: Center(
                  child: Text("Login"),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                _handleSignIn().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IndexPage(isDarkMode: widget.isDarkMode,)),
                  );
                });
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green
                ),
                child: Center(
                  child: Text("Sign in with google"),
                ),
              ),
            ),
            SizedBox(height: 20,),
            isLogin ?
            GestureDetector(
              onTap: (){
                _onPressedLogOutButton();
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green
                ),
                child: Center(
                  child: Text("Sign out"),
                ),
              ),
            ):
            GestureDetector(
              onTap: (){
                _onPressedLogInButton().then((value){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IndexPage(isDarkMode: widget.isDarkMode)),
                  );
                });
            },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green
                ),
                child: Center(
                  child: Text("Sign in with facebook"),
                ),
              ),
            ),
            SizedBox(height: 20,),

            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LinkedInWebLoginPage(),
                  ),
                ).then((value) => verifyLogin());
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green
                ),
                child: Center(
                  child: Text("Sign in with Linkedin"),
                ),
              ),
            ),

            SizedBox(height: 20,),

            GestureDetector(
              onTap: (){
                share();
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green
                ),
                child: Center(
                  child: Text("Share"),
                ),
              ),
            ),

            SizedBox(height: 20,),

            GestureDetector(
              onTap: (){
                //_checkBiometric();
                _checkBio();
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green
                ),
                child: Center(
                  child: Text("Sign in with Fingerprint"),
                ),
              ),
            ),
          ],
        ),
      );

  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  String  validateEmail(String ?value){
    if (value!.isEmpty) {
      return "Enter Email";
    } else if (!isNumeric(value) &&
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return "Please enter valid email";
    } else {
      return "";
    }
  }

  String validatePassword(String ?value){
    if (value!.isEmpty) {
      return "Please enter password";
    } else {
      return "";
    }
  }

  bool _validateInputs() {
    if (_logInformKey.currentState!.validate()) {
      _logInformKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> _onPressedLogOutButton() async {
    await widget.plugin.logOut();
    await _updateLoginInfo();
  }

  Future<void> _onPressedLogInButton() async {
    await widget.plugin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    await _updateLoginInfo();
    await widget.plugin.logOut();
  }

  Future<void> _updateLoginInfo() async {
    final plugin = widget.plugin;
    final token = await plugin.accessToken;
    FacebookUserProfile? profile;
    String? email;
    String? imageUrl;

    if (token != null) {
      print("token===$token");
      profile = await plugin.getUserProfile();
      print("profile===$profile");
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin.getUserEmail();
      }
      imageUrl = await plugin.getProfileImageUrl(width: 100);
    }

    setState(() {
      _token = token;
      _profile = profile;
      _email = email;
      _imageUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: Center(
          child: SingleChildScrollView(
            // child: ConstrainedBox(
            //   constraints: const BoxConstraints.expand(),
              child: _buildBody(),
            ),
        ),
       // )
    );
  }

  void verifyLogin() async {
    final storage = FlutterSecureStorage();

    String? user = await storage.read(key: Constants.user);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage1(),
        ),
      );
    }
  }

  bool? _hasBioSensor;

  LocalAuthentication authentication = LocalAuthentication();

  Future<void> _checkBio() async{
    try{
      _hasBioSensor  = await authentication.canCheckBiometrics;

      print(_hasBioSensor);

      if(_hasBioSensor!){
        _getAuth();
      }

    }on PlatformException catch(e){
      print(e);
    }
  }

  Future<void> _getAuth() async{
    bool isAuth = false;

    //loaded a dialog to scan fingerprint
    try{
      isAuth = await authentication.authenticate(
          localizedReason: 'Scan your finger print to access the app',
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true
      );

      //if fingerprint scan match then
      //isAuth = true
      // therefore will navigate user to WelcomePage/HomePage of the App
      if(isAuth){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>
            BottomNavigation(isDarkMode: widget.isDarkMode)));
      }

      print(isAuth);
    }on PlatformException catch(e){
      print(e);
    }

  }

 /* void _checkBiometric() async {
    // check for biometric availability
    final LocalAuthentication auth = LocalAuthentication();
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      print("error biome trics $e");
    }

    print("biometric is available: $canCheckBiometrics");

    // enumerate biometric technologies
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } catch (e) {
      print("error enumerate biometrics $e");
    }

    print("following biometrics are available");
    if (availableBiometrics.isNotEmpty) {
      availableBiometrics.forEach((ab) {
        print("\ttech: $ab");
      });
    } else {
      print("no biometrics are available");
    }

    // authenticate with biometrics
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Touch your finger on the sensor to login',
          useErrorDialogs: true,
          stickyAuth: false,
         // androidAuthStrings: AndroidAuthMessages(signInTitle: "Login to HomePage")
      );
      setState(() {
        _isAuthenticating = false;
      });
    } catch (e) {
      print("error using biometric auth: $e");
    }
    *//*setState(() {
      isAuth = authenticated ? true : false;
    });*//*

    print("authenticated: $authenticated");
  }*/

  /*Future networkConnection()async{
    bool isConnect = await isConnectNetworkWithMessage(context);
    if(!isConnect){
      return null;
    }else{

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigation()),
      );
    }
  }*/

  Future navigate() async{
    bool isConnect = await isConnectNetworkWithMessage(context);
    if(!isConnect){
      return null;
    }else{
     // if(_validateInputs()){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation(isDarkMode: widget.isDarkMode,appdata: widget.appdata)),
        );
     // }

    }
    // Do something
  }

  Future<bool> isConnectNetworkWithMessage(BuildContext context) async {
    var connectivityResult = await connectivity.checkConnectivity();
    bool isConnect = getConnectionValue(connectivityResult);
    if (!isConnect) {
      commonMessage(
        context,
        "Network connection required to fetch data.",
      );
    }
    return isConnect;
  }

  bool getConnectionValue(var connectivityResult) {
    bool status = false;
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = true;
        break;
      case ConnectivityResult.wifi:
        status = true;
        break;
      case ConnectivityResult.none:
        status = false;
        break;
      default:
        status = false;
        break;
    }
    return status;
  }

  void commonMessage(BuildContext context, String message) {
    print(message);
    print(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Message",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content:
          new Text(message, style: TextStyle(fontWeight: FontWeight.w500)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Ok",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // facebookAuthentication() async {
  //   await fbAuthManager.logOut();
  //   final result = await fbAuthManager.logIn(['email']);
  //   print(result);
  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       final token = result.accessToken.token;
  //       String url =
  //           'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token';
  //       // APIManager manager = APIManager(state.context);
  //
  //
  //       Map<String, dynamic> response =  await getFacebookDetails(url);
  //       print(response);
  //       print('Facebook Login Success');
  //       String email = response['email'] ?? "";
  //       String name = response['name'] ?? "";
  //       /*if (email != "") {
  //         Map params = {
  //           "userName": name ?? "",
  //           "emailId": email ?? "",
  //           "serviceName": 'FACEBOOK',
  //           "uniqueId": "",
  //           "loginPassword": "",
  //         };
  //       } else {
  //       }*/
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       print('Facebook Login cancelled By User');
  //       break;
  //     case FacebookLoginStatus.error:
  //       print(result.errorMessage);
  //       //commonMessageDialog(state.context, title: "Error", message: result.errorMessage);
  //       break;
  //   }
  // }

  // Future<Map<String, dynamic>> getFacebookDetails(String url) async {
  //   bool isConnect = await isConnectNetworkWithMessage(context);
  //   if (!isConnect){
  //
  //   }
  //   http.Response response = await http.get(Uri.parse(url));
  //   String data = response.body;
  //   return jsonDecode(data);
  // }

  /*  Future signInFB() async {
    final FacebookLoginResult result = await fbAuthManager.logIn(["email"]);
    final String token = result.accessToken.token;
    final response = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));
    final profile = jsonDecode(response.body);
    print(profile);
    return profile;
    }*/
}