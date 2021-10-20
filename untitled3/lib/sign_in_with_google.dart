//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInWithGoogle extends StatefulWidget {
  const SignInWithGoogle({Key? key}) : super(key: key);

  @override
  _SignInWithGoogleState createState() => _SignInWithGoogleState();
}

class _SignInWithGoogleState extends State<SignInWithGoogle> {

  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    clientId: '733916214158-8e0u0vb5lchobd4paufoavcata7otscc.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: (){
            _handleSignOut();
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
        )
      ),
    );
  }

  Future<void> _handleSignOut()async {

    await _googleSignIn.signOut().whenComplete((){
      _googleSignIn.signOut();
      Navigator.pop(context);
    });
   // _googleSignIn.signOut();
   // Navigator.pop(context);
  }


}
