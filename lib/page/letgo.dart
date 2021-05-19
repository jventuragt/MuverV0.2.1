import 'package:flutter/material.dart';
import 'package:move_app_1/page/home.dart';
import 'package:move_app_1/page/homedriver.dart';
import 'package:move_app_1/page/login.dart';
import 'package:move_app_1/page/signup.dart';
import 'package:move_app_1/widget/mybutton.dart';

import '../uidata.dart';

class LetGoPage extends StatelessWidget {
  LetGoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //TODO ARREGLAR ESPACIO DE FOTO Y BOTON
          Image.asset(
            'assets/images/letgo.png',
            width: size.width,
            height: size.height,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Container(
              width: size.width,
              //color: Colors.green,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Divider(),
                  MyButton(
                    caption: "USA TU UBICACION",
                    onPressed: () => {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (context) {
                        return new HomeDriverPage();
                      }))
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () => {
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(builder: (context) {
                        return new LoginPage();
                      }))
                    },
                    child: Text(
                      "Ve a LOGIN",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () => {
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(builder: (context) {
                        return new SignupPage();
                      }))
                    },
                    child: Text(
                      "NO TIENES CUENTA, "
                      " REGISTRATE!!!!",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
