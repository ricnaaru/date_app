import 'package:date_app/components/mini_checkbox.dart';
import 'package:date_app/main.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_row.dart';

const int _kEachItemDuration = 250;

class SequenceItem {
  final Widget indicator;
  final Widget title;
  final Widget content;

  SequenceItem({this.indicator, this.title, this.content})
      : assert(indicator != null),
        assert(title != null),
        assert(content != null);
}

class Sequence extends StatefulWidget {
  final List<SequenceItem> children;
  final double boxSize;
  final Color lineColor;
  final Color initialColor;
  final Color filledColor;
  final double dividerWidth;
  final SequenceController controller;
  final double titleContentRatio;

  Sequence(
      {@required this.children,
      double boxSize,
      Color lineColor,
      Color initialColor,
      Color filledColor,
      double dividerWidth,
      int selectedIndex,
      SequenceController controller,
      double titleContentRatio})
      : assert(selectedIndex == null || controller == null),
        this.boxSize = boxSize ?? ComponentsConfig.sequenceBoxSize,
        this.lineColor = lineColor ?? ComponentsConfig.sequenceLineColor,
        this.initialColor = initialColor ?? ComponentsConfig.sequenceInitialColor,
        this.filledColor = lineColor ?? ComponentsConfig.sequenceFilledColor,
        this.dividerWidth = dividerWidth ?? ComponentsConfig.sequenceDividerWidth,
        this.controller = controller ?? SequenceController(selectedIndex: selectedIndex ?? 0),
        this.titleContentRatio = titleContentRatio ?? ComponentsConfig.sequenceTitleContentRatio;

  @override
  State<StatefulWidget> createState() => _SequenceState();
}

class _SequenceState extends State<Sequence> with TickerProviderStateMixin {
  AnimationController mainController;
  Animation<double> scale;
  List<Animation<double>> scaleAnimations = [];
  Animation<double> width;
  List<Animation<Color>> colorAnimations = [];
  List<AnimationController> colorControllers = [];
  List<AnimationController> borderControllers = [];
  List<Animation<double>> checkboxScaleAnimations = [];

  @override
  void dispose() {
    super.dispose();
    mainController.dispose();
    for (AnimationController borderController in borderControllers) borderController.dispose();
    for (AnimationController colorController in colorControllers) colorController.dispose();
    _pageController.dispose();
    _bodyPageController.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    int totalItem = widget.children.length;

    int totalDuration = 300 + (_kEachItemDuration * totalItem);

    mainController =
        AnimationController(duration: Duration(milliseconds: totalDuration), vsync: this);

    double totalPortion = 0.5;

    for (int i = 0; i < totalItem; i++) {
      double portion = 0.5 / totalItem;
      double beginPortion = totalPortion;
      double endPortion = (totalPortion + portion).clamp(0.0, 1.0);

      Animation<double> scaleAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: mainController.view,
          curve: Interval(
            beginPortion,
            endPortion,
            curve: Curves.ease,
          ),
        ),
      );

      totalPortion += portion;

      scaleAnimations.add(scaleAnimation);

      AnimationController colorController =
          AnimationController(duration: Duration(milliseconds: 200), vsync: this);

      Animation<Color> colorAnimation = ColorTween(
        begin: widget.initialColor,
        end: widget.filledColor,
      ).animate(colorController);

      Animation<double> checkboxScaleAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(colorController);

      colorController.addListener(() {
        setState(() {});
      });

      colorControllers.add(colorController);
      colorAnimations.add(colorAnimation);
      checkboxScaleAnimations.add(checkboxScaleAnimation);

      AnimationController borderController =
          AnimationController(duration: Duration(milliseconds: 200), vsync: this);

      borderController.addListener(() {
        setState(() {});
      });

      borderControllers.add(borderController);
    }

    width = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: mainController.view,
        curve: Interval(
          0.0,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );

    mainController.forward();

    for (int i = 0; i <= widget.controller.selectedIndex; i++) {
      if (i < borderControllers.length) borderControllers[i].forward();
      if (i < widget.controller.selectedIndex) colorControllers[i].forward();
    }

    widget.controller.addListener(() {
      double startSupposeScroll = ((widget.controller.selectedIndex) * widget.boxSize) +
          ((widget.controller.selectedIndex) * widget.dividerWidth);
      double endSupposeScroll = ((widget.controller.selectedIndex + 1) * widget.boxSize) +
          ((widget.controller.selectedIndex + 2) * widget.dividerWidth);
      double startVisiblePosition = _scrollController.offset;
      double endVisiblePosition = _scrollController.offset + _maxWidth;

      if (_scrollController.hasClients) {
        if (endSupposeScroll > endVisiblePosition) {
          _scrollController.animateTo(
              (endSupposeScroll - _maxWidth).clamp(0.0, _scrollController.position.maxScrollExtent),
              duration: Duration(milliseconds: 200),
              curve: Curves.ease);
        } else if (startSupposeScroll < startVisiblePosition) {
          _scrollController.animateTo(
              (startSupposeScroll).clamp(0.0, _scrollController.position.maxScrollExtent),
              duration: Duration(milliseconds: 200),
              curve: Curves.ease);
        }
      }
      if (widget.controller.selectedIndex < widget.children.length) {
        _pageController.animateToPage(widget.controller.selectedIndex,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
        _bodyPageController.animateToPage(widget.controller.selectedIndex,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }

      for (int i = 0; i <= widget.controller.selectedIndex; i++) {
        int total = widget.children.length;

        for (int j = 0; j < total; j++) {
          if (i - 1 >= j) {
            colorControllers[j].forward();
          } else {
            colorControllers[j].reverse();
          }

          if (i >= j) {
            borderControllers[j].forward();
          } else {
            borderControllers[j].reverse();
          }
        }
      }
    });

    _pageController = PageController(initialPage: widget.controller.selectedIndex);

    _bodyPageController = PageController(initialPage: widget.controller.selectedIndex);
  }

  double _maxWidth = 0.0;

  PageController _pageController;
  PageController _bodyPageController;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int total = widget.children.length;
        double maxHeight = constraints.maxHeight;
        _maxWidth = constraints.maxWidth;

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            Container(
              height: maxHeight * widget.titleContentRatio,
              child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: widget.children.map((SequenceItem item) {
                    return item.title;
                  }).toList()),
            ),
            Container(
              height: maxHeight * (1.0 - widget.titleContentRatio),
              margin: EdgeInsets.only(top: maxHeight * widget.titleContentRatio),
              child: PageView(
                  controller: _bodyPageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: widget.children.map((SequenceItem item) {
                    return item.content;
                  }).toList()),
            ),
            Positioned(
                bottom: maxHeight * (1.0 - widget.titleContentRatio) -
                    ((widget.boxSize / 2) + ((widget.boxSize * 0.375 / 2) + 4.0)),
                left: 0.0,
                right: 0.0,
                child: AnimatedBuilder(
                  builder: (context, child) {
                    List<Widget> children = [];

                    for (int i = 0; i < total; i++) {
                      double borderWidth = widget.boxSize * 0.2;
                      double borderRadiusSize = widget.boxSize * 0.1;
                      SequenceItem child = widget.children[i];
                      Widget indicator;
                      if (child.indicator is Icon) {
                        Icon transitionIcon = child.indicator as Icon;
                        Color color = Color.lerp(
                            widget.filledColor, widget.initialColor, colorControllers[i].value);

                        indicator = Icon(transitionIcon.icon, color: color);
                      } else {
                        indicator = child.indicator;
                      }

                      children.add(ScaleTransition(
                        scale: scaleAnimations[i],
                        child: Stack(alignment: Alignment.center, children: [
                          Container(
                            height: widget.boxSize,
                            width: widget.boxSize, //colorAnimations[i].value,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(borderRadiusSize),
                              color: widget.filledColor,
                            ),
                          ),
                          Container(
                            height: widget.boxSize -
                                (borderWidth * borderControllers[i].value) +
                                (borderWidth * colorControllers[i].value),
                            width: widget.boxSize -
                                (borderWidth * borderControllers[i].value) +
                                (borderWidth * colorControllers[i].value),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(borderRadiusSize),
                              color: colorAnimations[i].value,
                            ),
                          ),
                          Opacity(
                            child: indicator,
                            opacity: 1.0,
                          ),
                          Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              child: ScaleTransition(
                                  scale: checkboxScaleAnimations[i],
                                  child: MiniCheckbox(
                                    value: widget.controller.selectedIndex > i,
                                    activeColor: widget.controller.selectedIndex >= i
                                        ? Color.lerp(widget.filledColor, Colors.black87, 0.4)
                                        : Color.lerp(widget.initialColor, Colors.black87, 0.4),
                                    inactiveColor: widget.controller.selectedIndex >= i
                                        ? Color.lerp(widget.filledColor, Colors.black87, 0.4)
                                        : Color.lerp(widget.initialColor, Colors.black87, 0.4),
                                    size: borderControllers[i].value * (widget.boxSize * 0.28),
                                    vsync: this,
                                  ))),
                          Opacity(
                              opacity: 0.5,
                              child: Material(
                                  color: Colors.transparent,
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: BorderRadius.circular(borderRadiusSize),
                                  child: InkWell(
                                    child: Container(
                                      height: widget.boxSize -
                                          (borderWidth * borderControllers[i].value) +
                                          (borderWidth * colorControllers[i].value),
                                      width: widget.boxSize -
                                          (borderWidth * borderControllers[i].value) +
                                          (borderWidth * colorControllers[i].value),
                                    ),
                                    onTap: () {
                                      if (widget.controller.selectedIndex >= i)
                                        widget.controller.selectedIndex = i;
                                    },
                                  ))),
                        ]),
                      ));
                    }
                    return Stack(children: [
                      Positioned(
                          top: (widget.boxSize - 5.0) / 2.0,
                          height: 5.0,
                          child: Container(
                              height: 5.0,
                              width: width.value * _maxWidth,
                              color: widget.lineColor)),
                      SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Builder(builder: (context) {
                          return Container(
                              width: (_scrollController.position.maxScrollExtent ?? 1.0) > 0.0
                                  ? null
                                  : _maxWidth,
                              child: AdvRow(
                                  margin: EdgeInsets.only(bottom: (widget.boxSize * 0.375 / 2) + 4.0),
                                  onlyInner: false,
                                  divider: RowDivider(widget.dividerWidth),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: children));
                        }),
                      )
                    ]);
                  },
                  animation: mainController.view,
                )),
          ]),
        ]);
      },
    );
  }
}

class SequenceController extends ValueNotifier<SequenceEditingValue> {
  int get selectedIndex => value.selectedIndex;

  set selectedIndex(int newSelectedIndex) {
    value = value.copyWith(selectedIndex: newSelectedIndex);
  }

  SequenceController({int selectedIndex})
      : super(selectedIndex == null
            ? SequenceEditingValue.empty
            : new SequenceEditingValue(selectedIndex: selectedIndex));

  SequenceController.fromValue(SequenceEditingValue value)
      : super(value ?? SequenceEditingValue.empty);

  void clear() {
    value = SequenceEditingValue.empty;
  }
}

@immutable
class SequenceEditingValue {
  const SequenceEditingValue({this.selectedIndex});

  final int selectedIndex;

  static const SequenceEditingValue empty = const SequenceEditingValue();

  SequenceEditingValue copyWith({int selectedIndex}) {
    return new SequenceEditingValue(selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  SequenceEditingValue.fromValue(SequenceEditingValue copy)
      : this.selectedIndex = copy.selectedIndex;

  @override
  String toString() => '$runtimeType(selectedIndex: $selectedIndex)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! SequenceEditingValue) return false;
    final SequenceEditingValue typedOther = other;
    return typedOther.selectedIndex == selectedIndex;
  }

  @override
  int get hashCode => selectedIndex.hashCode;
}
