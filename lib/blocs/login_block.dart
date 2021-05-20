import 'dart:async';

import 'package:provider/provider.dart';

class LoginBlock {
  //StreamController<String> _emailController

  final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();

  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  Dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
