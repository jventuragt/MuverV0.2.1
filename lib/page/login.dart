import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:move_app_1/page/homedriver.dart';
import 'package:move_app_1/page/verifyotp.dart';
import 'package:move_app_1/providers/login_controller.dart';
import 'package:move_app_1/uidata.dart';
import 'package:move_app_1/widget/loader2.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controller = TextEditingController();

 LoginController _con = new LoginController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool hidepass = true;
  Country _selected = Country.GT;
  final TextEditingController textEditingController =
      new TextEditingController();

  String phone;

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/bg1.png',
            width: size.width,
            height: size.height / 3,
            fit: BoxFit.fill,
          ),
          SingleChildScrollView(
             child: Container(
              height: 630,
              padding: EdgeInsets.only(
                  top: 160.0, left: 10.0, right: 10.0, bottom: 10.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Text("Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32)),
                        Text(
                          " con tu  ",
                          style: TextStyle(fontSize: 30),
                        ),
                      ]),
                      Text(
                        "numero telefonico",
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      //EMAIL/////////////////////////////////////////////EMAIL
                      /*  TextField(
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
                    ),*/
                        //////////////////PHONE//////////////////
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          CountryPicker(
                            showDialingCode: false,
                            showName: false,
                            onChanged: (Country country) {
                              setState(() {
                               // _selected = country;
                              });
                            },
                            selectedCountry: _selected,
                          ),
                          Flexible(
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              controller: textEditingController,
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
                                  hintText: "Telefono",
                                  hintStyle: TextStyle(color: Colors.black26),
                                  //filled: true,
                                  //fillColor: Colors.white,

                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: UIData.myBackground, width: 5.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8.0)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0)),
                          color: UIData.Bassic,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                          splashColor: UIData.Bassic,

                          ///////////////EMAIL SIGIN///////////////////
                         /* onPressed: () async {
                            await _firebaseAuth.signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                            Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(builder: (context) {
                              return new HomeDriverPage();
                            }));
                          },*/
                          
                          ////PHONE/////////////////
                          onPressed: () => {
                            Navigator.of(context).push(
                                new MaterialPageRoute(builder: (context) {
                                  return new OTPScreen();
                                }))
                          },
                          child: Text(
                            "SIGUIENTE",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


