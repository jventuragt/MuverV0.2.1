import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:move_app_1/page/phoneinput.dart';
import 'package:move_app_1/page/signup.dart';
import 'package:move_app_1/providers/login_controller.dart';
import 'package:move_app_1/service/google_signin_service.dart';
import 'package:move_app_1/uidata.dart';

import 'letgo.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  LoginController _con = new LoginController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool hidepass = true;
  final TextEditingController textEditingController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _builbottom = Container(
        margin: EdgeInsets.only(bottom: 40),
        //color: Colors.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            /* Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text("O conectate con tu cuenta:"),
            ),*/
            SizedBox(
              width: double.infinity,
              height: 40,
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                color: Colors.indigo,
                icon: Icon(
                  FontAwesomeIcons.facebook,
                  color: Colors.white,
                ),
                label: Expanded(
                  child: Center(
                    child: Text(
                      "Sign in with Facebook  !!PENDIENTE!!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child:
                  //loginBtn
                  RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  side: BorderSide(
                    color: UIData.PrimaryColor,
                    width: 1.0,
                  ),
                ),
                color: Colors.white,
                icon: Icon(
                  Icons.phone,
                  color: UIData.PrimaryColor,
                ),
                label: Expanded(
                  child: Center(
                    child: Text(
                      "Sign in with Phone  !!PENDIENTE!!",
                      style: TextStyle(color: UIData.PrimaryColor),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (context) {
                    return new PhoneInputPage();
                  }));
                },
              ),
            ),
          ],
        ));

    Widget _buildPageContent() {
      return Container(
          padding: EdgeInsets.all(20.0),
          //color: Colors.grey.shade800,
          child: ListView(children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Log in",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 30),
                    child: Text("", style: TextStyle(color: Colors.grey)),
                  ),

                  /*TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            print("clear");
                            textEditingController.clear();
                          },
                          child: Icon(
                            Icons.clear,
                            color: Colors.black26,
                          ),
                        ),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.black26),
                        //filled: true,
                        //fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey, width: 5.0),
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 16.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 8),
                    child:
                        Text("PASSWORD", style: TextStyle(color: Colors.grey)),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: hidepass,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              hidepass = !hidepass;
                            });
                          },
                          child: Icon(
                            Icons.remove_red_eye,
                            color: Colors.black26,
                          ),
                        ),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.black26),

                        //filled: true,
                        //fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey, width: 5.0),
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 16.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40, top: 16),
                    child: Text("Olvide mi Contraseña",
                        style: TextStyle(color: UIData.PrimaryColor)),
                  ),*/
                  //loginbtn,
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: MaterialButton(
                        color: UIData.PrimaryColor,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        splashColor: Colors.blueAccent,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Sign in with Google",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                ),
                              ),
                            ]),
                        onPressed: () {
                         signInWithGoogle(context);
                          
                          
                         
                        },
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  _builbottom
                ]),
          ]));
    }

    return Scaffold(
        appBar: new AppBar(
          title: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                  onTap: () => _gosignup(),
                  child: new Text(
                    'Sign up',
                    style: TextStyle(color: UIData.PrimaryColor),
                  ))),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: _buildPageContent());
  }

  _gosignup() {
    print("click");
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (context) {
      return new SignupPage();
    }));
  }
}
