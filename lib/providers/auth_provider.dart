import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  FirebaseAuth _firebaseAuth;

  AuthProvider() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  User getUser([String s]) {
    return _firebaseAuth.currentUser;
  }

  Future<bool> login(String email, String password, String telefono) async {
    String errorMessage;

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      print(error);

      //correor invalido
      //password incorrecto
      //no hay conexxion
      errorMessage = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    return true;
  }

  Future<bool> register(String email, String password) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
