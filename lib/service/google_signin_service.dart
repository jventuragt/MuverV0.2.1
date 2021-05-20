import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:move_app_1/model/client.dart';
import 'package:move_app_1/page/letgo.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference clients = FirebaseFirestore.instance.collection('client');
String verificationId;

bool showLoading = false;
final TextEditingController textEditingController = new TextEditingController();

void signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      final User client = authResult.user;

      var clientsData = {
        'uid': googleSignInAccount.displayName,
        'imagen': "google",
        'email': googleSignInAccount.email,
      };

      clients.doc(client.uid).get().then((doc) {
        if (doc.exists) {
          // old user
          doc.reference.update(clientsData);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LetGoPage(),
            ),
          );
        } else {
          // new user

          clients.doc(client.uid).set(clientsData);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LetGoPage(),
            ),
          );
        }
      });
    }
  } catch (PlatformException) {
    print(PlatformException);
    print("Sign in not successful !");
    // better show an alert here
  }
}
