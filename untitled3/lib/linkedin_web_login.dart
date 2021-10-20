import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled3/api/linkedin_access_token_client.dart';
import 'package:untitled3/api/linkedin_rest_client.dart';
import 'package:untitled3/api/response_models/linkedin_access_token.dart';
import 'package:untitled3/api/response_models/linkedin_user.dart';
import 'package:untitled3/constants.dart';
import 'package:untitled3/models/user.dart';
//import 'package:google_signin/api/linkedin_access_token_client.dart';
//import 'package:google_signin/api/linkedin_rest_client.dart';
//import 'package:google_signin/api/response_models/linkedin_access_token.dart';
//import 'package:google_signin/api/response_models/linkedin_user.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:google_signin/constants.dart';
//import 'package:google_signin/models/user.dart';
//import 'package:google_sign_in/api/linkedin_access_token_client.dart';
//import 'package:google_sign_in/api/linkedin_access_token_client.dart';
/*import 'package:linkedin_login/api/linkedin_access_token_client.dart';
import 'package:linkedin_login/api/linkedin_rest_client.dart';
import 'package:linkedin_login/api/response_models/linkedin_access_token.dart';
import 'package:linkedin_login/api/response_models/linkedin_user.dart';
import 'package:linkedin_login/constants.dart';
import 'package:linkedin_login/models/user.dart';*/
import 'package:webview_flutter/webview_flutter.dart';

class LinkedInWebLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String url = 'https://www.linkedin.com/oauth/v2/authorization?' +
        'response_type=code&client_id=${Constants.clientId}&' +
        'redirect_uri=${Constants.redirectURI}&' +
        'state=${Constants.linkedInStateKey}&' +
        'scope=${Constants.linkedInScope}';

    return SafeArea(
      child: Scaffold(
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (s) {
            if (s.contains(Constants.redirectURI) &&
                s.contains('?code=') &&
                s.contains('&state')) {
              s = s.split(Constants.redirectURI + '?code=')[1];
              s = s.split('&state=')[0];

              getAccessCode(context, s);
            }
          },
        ),
      ),
    );
  }

  void getAccessCode(BuildContext context, String key) async {
    final dio = Dio();
    dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';

    var client = LinkedInAccessTokenClient(dio);

    LinkedInAccessToken accessToken = await client.getAccessToken(
        'authorization_code',
        key,
        Constants.redirectURI,
        Constants.linkedInStateKey,
        Constants.clientId,
        Constants.clientSecretKey);

    if (accessToken.access_token != null &&
        accessToken.access_token.isNotEmpty) {
      dio.options.headers['Authorization'] =
          'Bearer ' + accessToken.access_token;
      final client = LinkedInRestClient(dio);

      LinkedInUser linkedInUser = await client.getCurrentUser(
          '(id,firstName,lastName,profilePicture(displayImage~:playableStreams))');

      if (linkedInUser != null &&
          linkedInUser.firstName != null &&
          linkedInUser.firstName.isNotEmpty) {
        String firstName = '';
        String lastName = '';
        String profileImage = '';

        if (linkedInUser.firstName != null &&
            linkedInUser.firstName['localized'] != null)
          firstName = getName(Map.from(linkedInUser.firstName['localized']));
        if (linkedInUser.firstName != null &&
            linkedInUser.lastName['localized'] != null)
          lastName = getName(Map.from(linkedInUser.lastName['localized']));

        if (linkedInUser.profilePicture != null &&
            linkedInUser.profilePicture['displayImage~'] != null &&
            linkedInUser.profilePicture['displayImage~']['elements'] != null)
          profileImage = getImageUrl(List.from(
              linkedInUser.profilePicture['displayImage~']['elements']));

        User user = User(
            id: linkedInUser.id,
            firstName: firstName,
            lastName: lastName,
            profileImage: profileImage,
            accessToken: accessToken.access_token,
            loggedInFrom: 'linkedIn');

        final storage = FlutterSecureStorage();
        await storage.write(key: Constants.user, value: json.encode(user.toJson()));

        Navigator.pop(context);
      }
    }
  }

  String getName(Map map) {
    if (map.containsKey('en_US'))
      return map['en_US'];
    else {
      return map.entries.first.value;
    }
  }

  String getImageUrl(List list) {
    if (list.last != null) {
      Map<String, dynamic> map = Map.from(list.last);
      if (map.containsKey('identifiers')) {
        if (List.from(map['identifiers']).last != null)
          return List.from(map['identifiers']).last['identifier'];
      }
    }
    return '';
  }
}
