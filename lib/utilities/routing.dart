import 'package:date_app/utilities/slide_left_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Routing {
  static Future<T> pushReplacement<T extends Object>(
      BuildContext context, Widget widget) async {
    var result = await Navigator.pushReplacement(
      context,
      SlideLeftRoute(
          widget: widget,
          settings: RouteSettings(name: widget.runtimeType.toString())),
    );
    return result;
  }

  static Future<T> push<T extends Object>(
      BuildContext context, Widget widget) async {
    var result = await Navigator.push(
      context,
      SlideLeftRoute(
          widget: widget,
          settings: RouteSettings(name: widget.runtimeType.toString())),
    );
    return result;
  }

  static Future<T> pushAndRemoveUntil<T extends Object>(
      BuildContext context, Widget widget, RoutePredicate predicate) async {
    var result = await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => widget,
            settings: RouteSettings(name: widget.runtimeType.toString())),
        predicate);
    return result;
  }
}
