import 'package:date_app/presenters/login.dart';
import 'package:date_app/utilities/assets.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_text_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends View<LoginPage> implements LoginInterface {
  LoginPresenter _presenter;
  double _height;
  double _width;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    Size size = MediaQuery.of(context).size;

    _presenter = LoginPresenter(context, this, interface: this);
    _width = size.width;
    _height = size.height;
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        CustomPaint(
          painter: ShapesPainter(_width, _height),
          child: AdvColumn(
              divider: ColumnDivider(16.0),
              margin: EdgeInsets.symmetric(horizontal: 32.0).copyWith(top: _height * 0.2),
              children: [
                Image.asset(Assets.logoBlack),
                AdvTextField(controller: _presenter.userNameCtrl),
                AdvTextField(controller: _presenter.passwordCtrl),
                AdvRow(mainAxisSize: MainAxisSize.min, divider: RowDivider(16.0), children: [
                  AdvButton(
                    dict.getString("register"),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    onPressed: _presenter.navigateToRegister,
                  ),
                  AdvButton(
                    dict.getString("login"),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    onPressed: _presenter.login,
                  ),
                ])
              ]),
        ),
      ]),
    );
  }

  @override
  void onLoginFailed() {
    setState(() {

    });
  }
}

class ShapesPainter extends CustomPainter {
  final double _height;
  final double _width;

  ShapesPainter(this._width, this._height);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Color.lerp(CompanyColors.accent, Colors.white, 0.5).withOpacity(0.8);
    final paint2 = Paint();
    paint2.color = Color.lerp(CompanyColors.primary, Colors.white, 0.5);
    final paint3 = Paint();
    paint3.color = Color.lerp(CompanyColors.primary, Colors.white, 0.5).withOpacity(0.6);

    var path1 = Path();
    var path11 = Path();
    var path22 = Path();
    var path2 = Path();

    path1.lineTo(_width, _height * 0.12);
    path1.lineTo(_width, 0);
    path1.close();

    path11.lineTo(0, _height * 0.08);
    path11.lineTo(_width, 0);
    path11.close();

    path22.moveTo(0, _height);
    path22.lineTo(_width, _height * 0.4);
    path22.lineTo(_width, _height);
    path22.close();

    path2.moveTo(0, _height * 0.88);
    path2.lineTo(_width, _height);
    path2.lineTo(0, _height);
    path2.close();

    canvas.drawPath(path1, paint);
    canvas.drawPath(path11, paint2);
    canvas.drawPath(path22, paint3);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
