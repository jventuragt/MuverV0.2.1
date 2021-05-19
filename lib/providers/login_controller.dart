import 'package:flutter/cupertino.dart';
import 'package:move_app_1/providers/auth_provider.dart';

class LoginController {
  BuildContext context;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();

  AuthProvider _authProvider;

  Future init(BuildContext context) {
    this.context = context;
    _authProvider = new AuthProvider();
  }

  void login() async {
    String email = emailController.text;
    String password = passwordController.text.trim();
    String telefono = telefonoController.text.trim();

    print("Email: $email");
    print("Password: $password");
    print("Telefono: $telefono");

    try {
      bool isLogin = await _authProvider.login(email, password, telefono);

      if (isLogin) {
        print("Usuario Login");
      } else {
        print("Usuario no Login");
      }
    } catch (error) {
      print("Error: $error");
    }
  }
}
