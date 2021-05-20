import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';
import 'package:move_app_1/providers/auth_provider.dart';
import 'package:move_app_1/providers/client_provider.dart';

import 'package:flutter_country_picker/flutter_country_picker.dart';

import '../uidata.dart';
import 'letgo.dart';

class VerifyOTPPage extends StatefulWidget {
  VerifyOTPPage({Key key}) : super(key: key);

  @override
  _PhoneInputPageState createState() {
    return _PhoneInputPageState();
  }
}

AuthProvider _authProvider;
ClientProvider _clientProvider;

class _PhoneInputPageState extends State<VerifyOTPPage> {
  Country _selected;

  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference drivers = FirebaseFirestore.instance.collection('users');
  bool showLoading = false;

  void register() async {
    // utils.Snackbar.showSnackbar(
    //   context, key, "Ingresar Todos los Caracteres");
    return;
  }

  //_progressDialog.show();

  /*var clientrData = {
    "username": username,
    //"email":  //TODO PONER ID MAIL,
    "uid": phoneAuthCredential.token,
    "id": "AuthPhone",
    //'photoUrl': phoneAuthCredential.verificationId,
    // "email": phoneAuthCredential.signInMethod,
  };*/

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildPageContent(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(20.0),
          //color: Colors.grey.shade800,
          child: ListView(children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Verifica tu numero de telefono",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 26, bottom: 26),
                    child: Text(
                        "Check your SMS messages. We've sent you the PIN at +502939123456"),
                  ),
                  Center(
                    child: VerificationCodeInput(
                      keyboardType: TextInputType.number,
                      length: 4,
                      onCompleted: (String value) {
                        //...
                        print(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30, top: 30),
                    child: Row(
                      children: <Widget>[
                        Text("Didn't receive SMS? ",
                            style: TextStyle(color: Colors.grey)),
                        Text(
                          "Resend Code",
                          style: TextStyle(color: UIData.PrimaryColor),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        color: UIData.PrimaryColor,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(builder: (context) {
                            return new LetGoPage();
                          }));
                        },
                        child: Text(
                          "VERIFY",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      )),
                ])
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildPageContent(context);
  }
}
