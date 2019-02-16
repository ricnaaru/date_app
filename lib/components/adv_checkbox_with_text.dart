import 'package:date_app/components/roundrect_checkbox.dart';
import 'package:date_app/utilities/global.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_row.dart';

class AdvCheckboxWithText extends StatefulWidget {
  final String text;
  final ValueNotifier<bool> controller;
  final ValueChanged<bool> onChanged;
  final TextStyle style;

  AdvCheckboxWithText(
      {bool value,
      this.text,
      ValueNotifier<bool> controller,
      this.onChanged,
      TextStyle style})
      : assert(controller == null || (value == null)),
        assert(controller == null || (onChanged == null)),
        this.controller = controller ?? ValueNotifier<bool>(value),
        this.style = style ?? TextStyle();

  @override
  State<StatefulWidget> createState() => _AdvCheckboxWithTextState();
}

class _AdvCheckboxWithTextState extends State<AdvCheckboxWithText> {
  @override
  Widget build(BuildContext context) {
    return widget.text == null
        ? RoundRectCheckbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: systemPrimaryColor,
            onChanged: (bool value) {
              setState(() {
                widget.controller.value = !widget.controller.value;

                if (widget.onChanged != null)
                  widget.onChanged(widget.controller.value);
              });
            },
            value: widget.controller.value)
        : InkWell(
            child: AdvRow(children: [
              Container(
                  child: RoundRectCheckbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: systemPrimaryColor,
                      onChanged: (bool value) {},
                      value: widget.controller.value),
                  margin: EdgeInsets.all(8.0)),
              Expanded(child: Text(widget.text)),
            ]),
            onTap: () {
              setState(() {
                widget.controller.value = !widget.controller.value;

                if (widget.onChanged != null)
                  widget.onChanged(widget.controller.value);
              });
            },
          );
  }
}
