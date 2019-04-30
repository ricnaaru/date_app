import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MiniCheckbox extends LeafRenderObjectWidget {
  const MiniCheckbox(
      {Key key,
        @required this.value,
        @required this.activeColor,
        @required this.inactiveColor,
        @required this.vsync,
        @required this.size});

  final bool value;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final ValueChanged<bool> onChanged = null;
  final TickerProvider vsync;
  final BoxConstraints additionalConstraints = const BoxConstraints();

  @override
  _RenderCheckbox createRenderObject(BuildContext context) => _RenderCheckbox(
    value: value,
    checkboxSize: size,
    activeColor: activeColor,
    inactiveColor: inactiveColor,
    onChanged: onChanged,
    vsync: vsync,
    additionalConstraints: additionalConstraints,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderCheckbox renderObject) {
    renderObject
      ..value = value
      ..checkboxSize = size
      ..activeColor = activeColor
      ..inactiveColor = inactiveColor
      ..onChanged = onChanged
      ..additionalConstraints = additionalConstraints
      ..vsync = vsync;
  }
}

//const double _kEdgeSize = 10.0 + 2.0;
//const Radius _kEdgeRadius = Radius.circular(10.0);
const double _kStrokeWidth = 2.0;

class _RenderCheckbox extends RenderToggleable {
  _RenderCheckbox({
    bool value,
    double checkboxSize,
    Color activeColor,
    Color inactiveColor,
    BoxConstraints additionalConstraints,
    ValueChanged<bool> onChanged,
    @required TickerProvider vsync,
  })  : _oldValue = value,
        _checkboxSize = checkboxSize ?? 0.0,
        super(
        value: value,
        tristate: false,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        onChanged: onChanged,
        additionalConstraints: additionalConstraints,
        vsync: vsync,
      );

  bool _oldValue;

  double get checkboxSize => _checkboxSize;
  double _checkboxSize;

  set checkboxSize(double newCheckboxSize) {
    if (newCheckboxSize == checkboxSize) return;
    _checkboxSize = newCheckboxSize;
  }

  @override
  set value(bool newValue) {
    if (newValue == value) return;
    _oldValue = value;
    super.value = newValue;
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isChecked = value == true;
  }

  // The square outer bounds of the checkbox at t, with the specified origin.
  // At t == 0.0, the outer rect's size is _kEdgeSize (Checkbox.width)
  // At t == 0.5, .. is _kEdgeSize - _kStrokeWidth
  // At t == 1.0, .. is _kEdgeSize
  RRect _outerRectAt(Offset origin, double t) {
    final double inset = 1.0 - (t - 0.5).abs() * 2.0;
    final double size = (checkboxSize + _kStrokeWidth) - inset * _kStrokeWidth;
    final Rect rect =
    Rect.fromLTWH(origin.dx + inset, origin.dy + inset, size, size);
    return RRect.fromRectAndRadius(rect, Radius.circular(checkboxSize));
  }

  // The checkbox's border color if value == false, or its fill color when
  // value == true or null.
  Color _colorAt(double t) {
    // As t goes from 0.0 to 0.25, animate from the inactiveColor to activeColor.
    return (t >= 0.25
        ? activeColor
        : Color.lerp(inactiveColor, activeColor, t * 4.0));
  }

  // White stroke used to paint the check and dash.
  void _initStrokePaint(Paint paint) {
    paint
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _kStrokeWidth;
  }

  void _drawBorder(Canvas canvas, RRect outer, double t, Paint paint) {
    assert(t >= 0.0 && t <= 0.5);
    final double size = outer.width;
    // As t goes from 0.0 to 1.0, gradually fill the outer RRect.
    RRect inner = outer.deflate(math.min(size / 1.0, _kStrokeWidth + size * t));
//    inner = RRect.fromRectAndRadius(inner.outerRect, Radius.circular(outer.width));
    canvas.drawDRRect(outer, inner, paint);
  }

  void _drawCheck(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    // As t goes from 0.0 to 1.0, animate the two check mark strokes from the
    // short side to the long side.
    final Path path = Path();
    final double size = (checkboxSize + _kStrokeWidth);
    final Offset start = Offset(size * 0.25, size * 0.55);
    final Offset mid = Offset(size * 0.4, size * 0.7);
    final Offset end = Offset(size * 0.75, size * 0.35);
    if (t < 0.5) {
      final double strokeT = t * 2.0;
      final Offset drawMid = Offset.lerp(start, mid, strokeT);
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + drawMid.dx, origin.dy + drawMid.dy);
    } else {
      final double strokeT = (t - 0.5) * 2.0;
      final Offset drawEnd = Offset.lerp(mid, end, strokeT);
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + mid.dx, origin.dy + mid.dy);
      path.lineTo(origin.dx + drawEnd.dx, origin.dy + drawEnd.dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawDash(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    // As t goes from 0.0 to 1.0, animate the horizontal line from the
    // mid point outwards.
    final double size = (checkboxSize + _kStrokeWidth);
    final Offset start = Offset(size * 0.2, size * 0.5);
    final Offset mid = Offset(size * 0.5, size * 0.5);
    final Offset end = Offset(size * 0.8, size * 0.5);
    final Offset drawStart = Offset.lerp(start, mid, 1.0 - t);
    final Offset drawEnd = Offset.lerp(mid, end, t);
    canvas.drawLine(origin + drawStart, origin + drawEnd, paint);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    paintRadialReaction(canvas, offset, size.center(Offset.zero));

    final Offset origin = offset +
        (size / 2.0 - Size.square((checkboxSize + _kStrokeWidth)) / 2.0);
    final AnimationStatus status = position.status;
    final double tNormalized =
    status == AnimationStatus.forward || status == AnimationStatus.completed
        ? position.value
        : 1.0 - position.value;

    // Four cases: false to null, false to true, null to false, true to false
    if (_oldValue == false || value == false) {
      final double t = value == false ? 1.0 - tNormalized : tNormalized;
      final RRect outer = _outerRectAt(origin, t);
      final Paint paint = Paint()..color = _colorAt(t);

      if (t <= 0.5) {
        final Paint innerFillPaint = Paint()
          ..color = Color.lerp(inactiveColor, Colors.white, 0.6);
        canvas.drawRRect(outer, innerFillPaint);
        _drawBorder(canvas, outer, t, paint);
      } else {
        canvas.drawRRect(outer, paint);

        _initStrokePaint(paint);
        final double tShrink = (t - 0.5) * 2.0;
        if (_oldValue == null)
          _drawDash(canvas, origin, tShrink, paint);
        else
          _drawCheck(canvas, origin, tShrink, paint);
      }
    } else {
      // Two cases: null to true, true to null
      final RRect outer = _outerRectAt(origin, 1.0);
      final Paint paint = Paint()..color = _colorAt(1.0);
      canvas.drawRRect(outer, paint);

      _initStrokePaint(paint);
      if (tNormalized <= 0.5) {
        final double tShrink = 1.0 - tNormalized * 2.0;
        if (_oldValue == true)
          _drawCheck(canvas, origin, tShrink, paint);
        else
          _drawDash(canvas, origin, tShrink, paint);
      } else {
        final double tExpand = (tNormalized - 0.5) * 2.0;
        if (value == true)
          _drawCheck(canvas, origin, tExpand, paint);
        else
          _drawDash(canvas, origin, tExpand, paint);
      }
    }
  }
}