import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);
  final FacebookLogin  plugin = FacebookLogin(debug: true);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _imageUrl;
  String? _email;
  String? _sdkVersion;

  @override
  void initState() {
    super.initState();

    _getSdkVersion();
    _updateLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = _token != null && _profile != null;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           // if (_sdkVersion != null) Text('SDK v$_sdkVersion'),

            if (isLogin)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildUserInfo(context, _profile!, _token!, _email),
              ),
            isLogin
                ? OutlinedButton(
              child: const Text('Log Out'),
              onPressed: _onPressedLogOutButton,
            )
                : OutlinedButton(
              child: const Text('Log In'),
              onPressed: _onPressedLogInButton,
            ),
            /*if (!isLogin && Platform.isAndroid)
              OutlinedButton(
                child: const Text('Express Log In'),
                onPressed: () => _onPressedExpressLogInButton(context),
              )*/
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, FacebookUserProfile profile,
      FacebookAccessToken accessToken, String? email) {
    final avatarUrl = _imageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (avatarUrl != null)
          Center(
            child: Image.network(avatarUrl),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('User: '),
            Text(
              '${profile.firstName} ${profile.lastName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Text('AccessToken: '),
        Text(
          accessToken.token,
          softWrap: true,
        ),
        if (email != null) Text('Email: $email'),
      ],
    );
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

  Future<void> _onPressedLogOutButton() async {
    await widget.plugin.logOut();
    await _updateLoginInfo();
  }

  Future<void> _onPressedExpressLogInButton(BuildContext context) async {
    final res = await widget.plugin.expressLogin();
    print("===============");
    print(res.status);
    print(FacebookLoginStatus.success);

    if (res.status == FacebookLoginStatus.success) {
      await _updateLoginInfo();
    } else {
      print("======");
      print(res.status);
      print(FacebookLoginStatus.success);
      await showDialog<Object>(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("Can't make express log in. Try regular log in."),
        ),
      );
    }
  }

  Future<void> _getSdkVersion() async {
    final sdkVesion = await widget.plugin.sdkVersion;
    setState(() {
      _sdkVersion = sdkVesion;
    });
  }
}
