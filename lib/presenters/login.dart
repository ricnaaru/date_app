import 'package:date_app/pages/home.dart';
import 'package:date_app/pages/home_container.dart';
import 'package:date_app/pages/register.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

abstract class LoginInterface {
  void onLoginFailed();
}

class LoginPresenter extends Presenter {
  LoginInterface _interface;
  AdvTextFieldController _userNameCtrl;
  AdvTextFieldController _passwordCtrl;

  LoginPresenter(BuildContext context, View<StatefulWidget> view, {LoginInterface interface})
      : this._interface = interface,
        super(context, view);

  @override
  void init() {
    _userNameCtrl = AdvTextFieldController(label: dict.getString("username"), maxLines: 1);
    _passwordCtrl =
        AdvTextFieldController(label: dict.getString("password"), maxLines: 1, obscureText: true);
  }

  AdvTextFieldController get passwordCtrl => _passwordCtrl;

  AdvTextFieldController get userNameCtrl => _userNameCtrl;

  void login() {
    view.process(() async {
      int errorCounter = 0;
      String username = _userNameCtrl.text ?? "";
      String password = _passwordCtrl.text ?? "";

      if (username.isEmpty) {
        errorCounter++;
        _userNameCtrl.error = dict.getString("err_username_empty");
      }

      if (password.isEmpty) {
        errorCounter++;
        _passwordCtrl.error = dict.getString("err_password_empty");
        _passwordCtrl.error = dict.getString("err_password_not_match");
      }

      if (errorCounter > 0) {
        _interface.onLoginFailed();
        return;
      }

      bool success = await DataEngine.login(username, password);

      if (!success) {
        _passwordCtrl.error = dict.getString("err_password_not_match");
      } else {
        Routing.pushReplacement(context, HomeContainerPage());
      }
    });
  }

  void navigateToRegister() {
    Routing.push(context, RegisterPage());
  }
}
