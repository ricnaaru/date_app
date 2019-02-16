import 'package:date_app/utilities/global.dart';
import 'package:flutter/material.dart';

class AdvFloatingButton extends StatefulWidget {
  final List<VoidCallback> callbacks;
  final String tooltip;
  final List<IconData> icons;

  AdvFloatingButton({this.callbacks, this.tooltip, this.icons})
      : assert((callbacks?.length ?? 0) == 0 ||
            (callbacks?.length ?? 0) == (icons?.length ?? 0));

  @override
  _AdvFloatingButtonState createState() => _AdvFloatingButtonState();
}

class _AdvFloatingButtonState extends State<AdvFloatingButton>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: systemPrimaryColor,
      end: systemRedColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));

    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    isOpened = !isOpened;
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        heroTag: "Toggle",
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          color: Colors.white,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    for (int i = (widget.icons?.length ?? 0) - 1; i >= 0; i--) {
      children.add(Transform(
        transform: Matrix4.translationValues(
          0.0,
          _translateButton.value * (i + 1).toDouble(),
          0.0,
        ),
        child: Opacity(
          opacity: _animationController.value,
          child: FloatingActionButton(
            elevation: 4.0,
            heroTag: widget.icons[i].toString(),
            onPressed: widget.callbacks == null ? null : widget.callbacks[i],
            child: Icon(widget.icons[i]),
          ),
        ),
      ));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: children..add(toggle()));
  }
}
