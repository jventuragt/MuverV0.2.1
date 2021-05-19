import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';
import 'package:move_app_1/page/homedriver.dart';
//import 'package:move_app_1/providers/users_provider.dart';
import 'package:move_app_1/uidata.dart';
import 'package:move_app_1/widget/mybutton.dart';
//import 'package:phone_verification/screens/home_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference drivers = FirebaseFirestore.instance.collection('driver');
  Country _selected = Country.GT;
  String verificationId;

  bool showLoading = false;
  final TextEditingController textEditingController =
      new TextEditingController();

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final UserCredential authResult =
          await _auth.signInWithCredential(phoneAuthCredential);

      final User driver = authResult.user;

      

      var driverData = {
        "id": phoneController.text,
        //"email": //TODO PONER ID MAIL,
        'token': phoneAuthCredential.token,
        "provider": 'AuthPhone',
        // 'photoUrl': phoneAuthCredential.token,
        // "email": phoneAuthCredential.signInMethod,
      };

      setState(() {
        showLoading = false;
      });

      drivers.doc(driver.uid).get().then((doc) {
        if (doc.exists) {
          doc.reference.update(driverData);

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeDriverPage()));
        } else {
          drivers.doc(driver.uid).set(driverData);
        }
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

     _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(e.message)));
 
    }
  }
/////////////////////////PHONEAUTH/////////////////////////////////////////////////
 
  
  getMobileFormWidget(context) {
    return Column(
      children: [
        Spacer(),
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
            controller: phoneController,
            keyboardType: TextInputType.phone,
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
                  borderSide:
                      BorderSide(color: UIData.myBackground, width: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
          ),
        ),
        FlatButton(
          onPressed: () async {
            setState(() {
              showLoading = true;
            });

            await _auth.verifyPhoneNumber(
              phoneNumber: phoneController.text,
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  showLoading = false;
                });
                //signInWithPhoneAuthCredential(phoneAuthCredential);
              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  showLoading = false;
                });
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text(verificationFailed.message)));
              },
              codeSent: (verificationId, resendingToken) async {
                setState(() {
                  showLoading = false;
                  currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {},
            );
          },
          child: MyButton(
            caption: "INGRESAR",
          ),
        ),
        Spacer(),
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: otpController,
          decoration: InputDecoration(
            hintText: "Codigo OTP",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: MyButton(
            caption: "ENVIAR",
          ),
        ),
        Spacer(),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';
import 'package:move_app_1/page/homedriver.dart';
import 'package:move_app_1/uidata.dart';
import 'package:move_app_1/widget/mybutton.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen(this.phone);

  //VerifyOTPPage({Key key, this.phone}) : super(key: key);

  @override
  _OTPScreenState createState() {
    return _OTPScreenState();
  }
}

FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference drivers = FirebaseFirestore.instance.collection('driver');
Country _selected = Country.GT;
String verificationId;

class _OTPScreenState extends State<OTPScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  String verificationId;

  bool showLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential?.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeDriverPage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: UIData.myBackground,
      appBar: new AppBar(
        backgroundColor: UIData.myBackground,
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Verificacion de Telefono",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              'Verify +502-${widget.phone}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Text("Ingresa tu codigo OTP"),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  VerificationCodeInput(
                    keyboardType: TextInputType.number,
                    length: 6,
                    itemSize: 40,
                    onCompleted: (pin) async {
                      try {
                        await FirebaseAuth.instance
                            .signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: _verificationCode,
                                smsCode: pin))
                            .then((value) async {
                          if (value.user != null) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeDriverPage()),
                                (route) => false);
                          }
                        });
                      } catch (e) {
                        FocusScope.of(context).unfocus();
                        _scaffoldkey.currentState.showSnackBar(
                            SnackBar(content: Text('invalid OTP')));
                      }
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: MyButton(
                    caption: "VERIFICAR AHORA",
                    onPressed: () {
                      _getOtpFormWidget(context);
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /* _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+502${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeDriverPage()),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 10));
  }*/

  _getOtpFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: otpController,
          decoration: InputDecoration(
            hintText: "numero de confitmacion",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed: () async {
            PhoneAuthCredential pushReplacementNamed =
                PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otpController.text);

            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Text("VERIFY"),
          color: Colors.blue,
          textColor: Colors.white,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }
}*/
