import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move_app_1/model/client.dart';
import 'package:move_app_1/providers/auth_provider.dart';
import 'package:move_app_1/providers/client_provider.dart';

//import 'package:move_app_1/src/utils/snackbar.dart' as utils;

class ClientRegisterController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmpasswordController = new TextEditingController();

  AuthProvider _authProvider;
  ClientProvider _clientProvider;
  //ProgressDialog _progressDialog;
  bool _userLoginAutoValidate = false;
  get task => null;

  Future init(BuildContext context) {
    this.context = context;
    _authProvider = new AuthProvider();
    _clientProvider = new ClientProvider();

    // _progressDialog =
    //   MyProgressDialog.createProgressDialog(context, "Cargando....");
  }

  void register() async {
    String username = usernameController.text;
    String confirmpassword = confirmpasswordController.text;
    String email = emailController.text;
    String password = passwordController.text;

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    print("Email: $email");
    print("Password: $password");

    if (username.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmpassword.isEmpty) {
      //  print("Ingresar Todos los Caracteres");
      // utils.Snackbar.showSnackbar(
      //  context, key, "Ingresar Todos los Caracteres");
      return;
    }
    if (confirmpassword != password) {
      //print("No Coincide");
      //  utils.Snackbar.showSnackbar(context, key, "No Coincide");
      return;
    }
    if (password.length < 6) {
      //print("Minimo 6 Caracteres");
      // utils.Snackbar.showSnackbar(context, key, "Minimo 6 Caracteres");
      return;
    }
    // _progressDialog.show();
    try {
      bool isRegister = await _authProvider.register(email, password);

      if (isRegister) {
        Clients client = new Clients(
          id: _authProvider.getUser().uid,
          email: _authProvider.getUser().email,
          username: username,
        );

        await _clientProvider.create(client);

        //  _progressDialog.hide();

        Navigator.pushNamedAndRemoveUntil(
            context, "driver/map", (route) => false);

        // utils.Snackbar.showSnackbar(context, key, "Proceso Exitoso");
        print("Registro con Exito");
      } else {
        // _progressDialog.hide();
        print("Contaseña Incorrecta");
        // utils.Snackbar.showSnackbar(context, key, "Contaseña Incorrecta");
      }
    } catch (error) {
      //  _progressDialog.hide();
      print("Error: $error");
      //utils.Snackbar.showSnackbar(context, key, "Error: $error");
    }
  }

  bool get userLoginAutoValidate => _userLoginAutoValidate;
  set userLoginAutoValidate(bool value) {
    _userLoginAutoValidate = value;
    notifyListeners();
  }

  void notifyListeners() {}

  clearAllModels() {
    _userLoginAutoValidate = false;
  }
}
