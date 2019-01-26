import 'package:flutter/material.dart';
import 'package:date_app/utilities/global.dart' as global;

class AdvDialog extends StatelessWidget {
  final Widget child;

  AdvDialog({this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        constraints: BoxConstraints(minHeight: 24.0),
        margin: EdgeInsets.all(16.0),
        child: Stack(
          children: [
            child,
            Positioned(
              top: 0.0,
              right: 0.0,
              child: InkWell(
                child: Icon(Icons.close, color: global.systemRedColor),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
