import 'package:date_app/utilities/localization.dart';
import 'package:flutter/material.dart';

abstract class View<T extends StatefulWidget> extends State<T> {
  bool _firstRun = true;
  bool _processing = false;
  DateDict _dict;

  DateDict get dict => _dict;

  @override
  Widget build(BuildContext context) {
    if (_firstRun) {
      initStateWithContext(context);
      _firstRun = false;
    }

    return buildView(context);
  }

  void initStateWithContext(BuildContext context) {
    _dict = DateDict.of(context);
  }

  Widget buildView(BuildContext context);

  bool isProcessing() => _processing;

  Future<void> process(Function f) async {
    setState(() {
      _processing = true;
    });
    await f();
    if (this.mounted) {
      setState(() {
        _processing = false;
      });
    }
  }
}