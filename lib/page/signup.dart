import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:move_app_1/page/letgo.dart';
import 'package:move_app_1/providers/login_controller.dart';
import '../uidata.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  final loginProvider = new LoginController();

  SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Country _selected = Country.GT;
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
    Size size = MediaQuery.of(context).size;
    Widget _buildPageContent() {
      return Container(
          //color: Colors.green,
          width: size.width,
          height: size.height - 80,
          padding: EdgeInsets.all(20.0),
          //color: Colors.grey.shade800,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Registrate",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Nombre",
                              hintStyle: TextStyle(color: Colors.black26),
                              //filled: true,
                              //fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 5.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 16.0)),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Apellido",
                              hintStyle: TextStyle(color: Colors.black26),
                              //filled: true,
                              //fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 5.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 16.0)),
                        ),
                      ),
                    ],
                  ),
                ),

                TextField(
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
                  padding: const EdgeInsets.only(bottom: 8, top: 16),
                  child: Text("CODIGO DE PAIS",
                      style: TextStyle(color: Colors.grey)),
                ),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CountryPicker(
                      showDialingCode: true,
                      showName: false,
                      onChanged: (Country country) {
                        setState(() {
                          _selected = country;
                        });
                      },
                      selectedCountry: _selected,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _telefonoController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            hintText: "Numero de Telefono",
                            hintStyle: TextStyle(color: Colors.black26),
                            //filled: true,
                            //fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueGrey, width: 5.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 16.0)),
                      ),
                    ),
                  ],
                ),
                //loginbtn,
                //Spacer(),

                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                          color: UIData.PrimaryColor,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () async {
                            await _firebaseAuth.createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _telefonoController.text);
                            Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(builder: (context) {
                              return new LetGoPage();
                            }));
                          },
                          child: Text(
                            "REGISTRATE",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )),
                  ),
                ),
              ]));
    }

    return Scaffold(
        appBar: new AppBar(
          title: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                  onTap: () => _gologin(),
                  child: new Text(
                    'Login',
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
        body: SingleChildScrollView(child: _buildPageContent()));
  }

  _gologin() {
    print("click");
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (context) {
      return new LoginPage();
    }));
  }
}
