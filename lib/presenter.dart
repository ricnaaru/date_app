import 'package:date_app/utilities/localization.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';

abstract class Presenter {
  final View _view;
  DateDict _dict;
  BuildContext _context;

  View get view => _view;
  DateDict get dict => _dict;
  BuildContext get context => _context;

  Presenter(this._context, this._view) {
    _dict = DateDict.of(_context);
    init();
  }

  void init();
}