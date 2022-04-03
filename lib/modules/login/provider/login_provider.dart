import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/login_page.dart';

final loginProviderlogic = ChangeNotifierProvider((ref) => LoginProvider());

class LoginProvider extends ChangeNotifier {
  final _email = TextEditingController();
  final _password = TextEditingController();

  TextEditingController get email => _email;
  TextEditingController get password => _password;

  set setEmail(String val) {
    _email.text = val;
  }

  set setPassword(String val) {
    _password.text = val;
  }

  bool _isLoading = false;
  bool _isLoading2 = false;

  bool get isLoading => _isLoading;
  bool get isLoading2 => _isLoading2;

  void loading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void loading2() {
    _isLoading2 = !_isLoading2;
    notifyListeners();
  }

  void switchType() {
    if (type == Status.signUp) {
      type = Status.login;
      notifyListeners();
    } else {
      type = Status.signUp;
      notifyListeners();
    }
  }
}
