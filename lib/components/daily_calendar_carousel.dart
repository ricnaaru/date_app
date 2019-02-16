import 'package:date_app/pages/event.dart';
import 'package:date_app/pages/event_detail.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/utilities/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// A Calculator.
import 'package:intl/intl.dart' show DateFormat;
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_visibility.dart';
import 'package:pit_components/consts/textstyles.dart' as ts;
import 'package:pit_components/pit_components.dart';
import 'package:pit_components/utils/utils.dart';

/// A Calculator.

/// A Calculator.

/// A Calculator.

const int _kAnimationDuration = 300;

enum PickType {
  day,
  month,
  year,
}

class CalendarStyle {
  final TextStyle defaultHeaderTextStyle = ts.fs20.copyWith(color: PitComponents.datePickerHeaderColor);
  final TextStyle defaultPrevDaysTextStyle = ts.fs14.copyWith(color: PitComponents.datePickerPrevDaysColor);
  final TextStyle defaultNextDaysTextStyle = ts.fs14.copyWith(color: PitComponents.datePickerNextDaysDaysColor);
  final TextStyle defaultDaysTextStyle = ts.fs14.copyWith(color: PitComponents.datePickerWeekdayColor);
  final TextStyle defaultTodayTextStyle = ts.fs14.copyWith(color: PitComponents.datePickerTodayTextColor);
  final TextStyle defaultSelectedDayTextStyle = ts.fs14.copyWith(color: PitComponents.datePickerSelectedTextColor);
  final TextStyle daysLabelTextStyle = ts.fs14.copyWith(color: PitComponents.datePickerDaysLabelColor);
  final TextStyle defaultNotesTextStyle = ts.fs14.copyWith(color: PitComponents.datePickerMarkedDaysDaysColor);
  final TextStyle defaultWeekendTextStyle = ts.fs14.copyWith(color: PitComponents.datePickerWeekendColor);
  final Widget defaultMarkedDateWidget = Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      color: Colors.red,
      //PitComponents.datePickerMarkedDaysDaysColor,
      height: 4.0,
      width: 4.0,
      margin: EdgeInsets.only(bottom: 4.0),
    ),
  );
  final Color todayBorderColor = PitComponents.datePickerTodayColor;
  final Color todayButtonColor = PitComponents.datePickerTodayColor;
  final Color selectedDayButtonColor = PitComponents.datePickerSelectedColor;

//  final Color selectedDayBorderColor = PitComponents.datePickerSelectedColor;

  final List<String> weekDays;
  final double viewportFraction;
  final Color prevMonthDayBorderColor;
  final Color thisMonthDayBorderColor;
  final Color nextMonthDayBorderColor;
  final double dayPadding;
  final Color dayButtonColor;
  final bool daysHaveCircularBorder;
  final Color iconColor;
  final EdgeInsets headerMargin;
  final double childAspectRatio;
  final EdgeInsets weekDayMargin;

  CalendarStyle({
    this.weekDays = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'],
    this.viewportFraction = 1.0,
    this.prevMonthDayBorderColor = Colors.transparent,
    this.thisMonthDayBorderColor = Colors.transparent,
    this.nextMonthDayBorderColor = Colors.transparent,
    this.dayPadding = 2.0,
    this.dayButtonColor = Colors.transparent,
    this.daysHaveCircularBorder,
    this.iconColor = Colors.blueAccent,
    this.headerMargin = const EdgeInsets.symmetric(vertical: 16.0),
    this.childAspectRatio = 1.0,
    this.weekDayMargin = const EdgeInsets.only(bottom: 4.0),
  });
}

class DailyCalendarCarousel extends StatefulWidget {
  final DateTime selectedDateTime;
  final Function(DateTime) onDayPressed;
  final CalendarStyle calendarStyle;
  final DateTime minDateTime;
  final DateTime maxDateTime;
  final List<EventItem> events;

  DailyCalendarCarousel({
    Key key,
    List<String> weekDays = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'],
    double viewportFraction = 1.0,
    Color prevMonthDayBorderColor = Colors.transparent,
    Color thisMonthDayBorderColor = Colors.transparent,
    Color nextMonthDayBorderColor = Colors.transparent,
    double dayPadding = 2.0,
    Color dayButtonColor = Colors.transparent,
    this.selectedDateTime,
    bool daysHaveCircularBorder,
    this.onDayPressed,
    Color iconColor = Colors.blueAccent,
    List<EventItem> events = const [],
    EdgeInsets headerMargin = const EdgeInsets.symmetric(vertical: 16.0),
    double childAspectRatio = 1.0,
    EdgeInsets weekDayMargin = const EdgeInsets.only(bottom: 4.0),
    this.minDateTime,
    this.maxDateTime,
  })  : this.events = events ?? const [],
        this.calendarStyle = CalendarStyle(
          weekDays: weekDays,
          viewportFraction: viewportFraction,
          prevMonthDayBorderColor: prevMonthDayBorderColor,
          thisMonthDayBorderColor: thisMonthDayBorderColor,
          nextMonthDayBorderColor: nextMonthDayBorderColor,
          dayPadding: dayPadding,
          dayButtonColor: dayButtonColor,
          daysHaveCircularBorder: daysHaveCircularBorder,
          iconColor: iconColor,
          headerMargin: headerMargin,
          childAspectRatio: childAspectRatio,
          weekDayMargin: weekDayMargin,
        ),
        super(key: key);

  @override
  DailyCalendarCarouselState createState() => DailyCalendarCarouselState();
}

class DailyCalendarCarouselState extends State<DailyCalendarCarousel> with TickerProviderStateMixin {
  GlobalKey<DayCalendarState> _dayKey = GlobalKey<DayCalendarState>();
  GlobalKey<MonthCalendarState> _monthKey = GlobalKey<MonthCalendarState>();
  GlobalKey<YearCalendarState> _yearKey = GlobalKey<YearCalendarState>();
  AnimationController _dayMonthAnim;
  AnimationController _monthYearAnim;

  @override
  void initState() {
    super.initState();
    _dayMonthAnim = AnimationController(duration: Duration(milliseconds: _kAnimationDuration), vsync: this);
    _monthYearAnim = AnimationController(duration: Duration(milliseconds: _kAnimationDuration), vsync: this, value: 1.0);
  }

  @override
  dispose() {
    _dayMonthAnim.dispose();
    _monthYearAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _selectedDateTime =
        DateTime(widget.selectedDateTime.year, widget.selectedDateTime.month, widget.selectedDateTime.day);
    List<Widget> children = [
      YearCalendar(
        mainContext: context,
        key: _yearKey,
        monthKey: _monthKey,
        calendarStyle: widget.calendarStyle,
        monthYearAnim: _monthYearAnim,
        selectedDateTime: _selectedDateTime,
        events: widget.events,
        minDateTime: widget.minDateTime,
        maxDateTime: widget.maxDateTime,
      ),
      MonthCalendar(
        mainContext: context,
        key: _monthKey,
        dayKey: _dayKey,
        yearKey: _yearKey,
        calendarStyle: widget.calendarStyle,
        dayMonthAnim: _dayMonthAnim,
        monthYearAnim: _monthYearAnim,
        selectedDateTime: _selectedDateTime,
        onDayPressed: widget.onDayPressed,
        events: widget.events,
        minDateTime: widget.minDateTime,
        maxDateTime: widget.maxDateTime,
      ),
      DayCalendar(
        mainContext: context,
        key: _dayKey,
        monthKey: _monthKey,
        calendarStyle: widget.calendarStyle,
        dayMonthAnim: _dayMonthAnim,
        selectedDateTime: _selectedDateTime,
        onDayPressed: widget.onDayPressed,
        events: widget.events,
        minDateTime: widget.minDateTime,
        maxDateTime: widget.maxDateTime,
      ),
    ];

    return Stack(children: children);
  }

  void onFabTapped() {
    _dayKey.currentState.onFabTapped();
  }
}

class DayCalendar extends StatefulWidget {
  final BuildContext mainContext;
  final GlobalKey<MonthCalendarState> monthKey;
  final AnimationController dayMonthAnim;
  final CalendarStyle calendarStyle;
  final List<EventItem> events;
  final DateTime selectedDateTime;
  final Function(DateTime) onDayPressed;
  final DateTime minDateTime;
  final DateTime maxDateTime;

  DayCalendar({
    this.mainContext,
    Key key,
    this.monthKey,
    this.dayMonthAnim,
    this.calendarStyle,
    this.events,
    this.selectedDateTime,
    this.onDayPressed,
    this.minDateTime,
    this.maxDateTime,
  }) : super(key: key);

  @override
  DayCalendarState createState() => DayCalendarState();
}

class DayCalendarState extends State<DayCalendar> with TickerProviderStateMixin {
  /// The first run, this will be shown (0.0 [widget.dayMonthAnim]'s value)
  ///
  /// When this title is tapped [_handleDayTitleTapped], we will give this the
  /// fade out animation ([widget.dayMonthAnim]'s value will gradually change
  /// from 0.0 to 1.0)
  ///
  /// When one of [MonthCalendar]'s boxes is tapped [_handleMonthBoxTapped],
  /// we will give this the fade in animation ([widget.dayMonthAnim]'s value
  /// will gradually change from 1.0 to 0.0)

  // Page Controller
  PageController _pageCtrl;

  /// Start Date from each page
  /// the selected page is on index 1,
  /// 0 is for previous month,
  /// 2 is for next month
  List<DateTime> _pageDates = List(3);

  /// Used to mark start and end of week days for rendering boxes purpose
  List<int> _startWeekday = [0, 0, 0];
  List<int> _endWeekday = [0, 0, 0];

  /// Selected DateTime
  DateTime _selectedDateTime;

  /// Transition that this Widget will go whenever this' title is tapped
  /// [_handleDayTitleTapped] or one of [MonthCalendar]'s boxes is tapped
  /// [_handleMonthBoxTapped]
  ///
  /// This tween will always begin from full expanded offset and size
  /// and end to one of [MonthCalendar]'s boxes offset and size
  Tween<Rect> rectTween;

  AnimationController _listAnimation;
  List<EventItem> selectedDateEvents;

  @override
  initState() {
    super.initState();

    /// Whenever day to month animation is finished, reset rectTween to null
    widget.dayMonthAnim.addListener(() {
      if (widget.dayMonthAnim.status == AnimationStatus.completed || widget.dayMonthAnim.status == AnimationStatus.dismissed) {
        rectTween = null;
      }
    });

    _selectedDateTime = widget.selectedDateTime;

    /// setup pageController
    _pageCtrl = PageController(initialPage: 1, keepPage: true, viewportFraction: widget.calendarStyle.viewportFraction);

    /// set _pageDates for the first time
    this._setPage();

    _listAnimation = AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (selectedDateEvents != null) _listAnimation.forward();
    });
  }

  @override
  dispose() {
    _pageCtrl.dispose();
    _listAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext parentContext) {
//    timeDilation = 5.0;
    Widget dayContent = _buildDayContent(parentContext);

    return AnimatedBuilder(
        animation: widget.dayMonthAnim,
        builder: (BuildContext context, Widget child) {
          if (rectTween == null)
            return AdvVisibility(
                visibility: widget.dayMonthAnim.value == 1.0 ? VisibilityFlag.gone : VisibilityFlag.visible, child: dayContent);

          /// rect tween set when one of these two occasions occurs
          /// 1. Day Title tapped so it has to be squeezed inside month boxes
          ///
          ///     See also [_handleDayTitleTapped]
          /// 2. One of month boxes is tapped, so Day content should be expanded
          ///     See also [_handleDayBoxTapped]

          /// calculate lerp of destination rect according to current widget.dayMonthAnim.value
          final Rect destRect = rectTween.evaluate(widget.dayMonthAnim);

          /// minus padding for each horizontal and vertical axis
          final Size destSize = Size(destRect.size.width - (widget.calendarStyle.dayPadding * 2),
              destRect.size.height - (widget.calendarStyle.dayPadding * 2));
          final double top = destRect.top + widget.calendarStyle.dayPadding;
          final double left = destRect.left + widget.calendarStyle.dayPadding;

          double xFactor = destSize.width / rectTween.begin.width;
          double yFactor = destSize.height / rectTween.begin.height;

          /// scaling the content inside
          final Matrix4 transform = Matrix4.identity()..scale(xFactor, yFactor, 1.0);

          /// keep the initial size, so we can achieve destination scale
          /// example :
          /// rectTween.begin.width * destSize.width / rectTween.begin.width => destSize.width

          /// For the Opacity :
          /// as the scaling goes from 0.0 to 1.0, we progressively change the opacity from 1.0 to 0.0
          return Positioned(
              top: top,
              width: rectTween.begin.width,
              height: rectTween.begin.height,
              left: left,
              child:
                  Opacity(opacity: 1.0 - widget.dayMonthAnim.value, child: Transform(transform: transform, child: dayContent)));
        });
  }

  Widget _buildDayContent(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return Column(
      children: <Widget>[
        AdvRow(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          children: <Widget>[
            IconButton(
              onPressed: () => _setPage(page: 0),
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: widget.calendarStyle.iconColor,
              ),
            ),
            Builder(builder: (BuildContext childContext) {
              String title = DateFormat.yMMM().format(this._pageDates[1]);
              return Expanded(
                child: InkWell(
                  child: Container(
                    padding: widget.calendarStyle.headerMargin,
                    child: Text(
                      '$title',
                      textAlign: TextAlign.center,
                      style: widget.calendarStyle.defaultHeaderTextStyle,
                    ),
                  ),
                  onTap: () => _handleDayTitleTapped(context),
                ),
              );
            }),
            IconButton(
              padding: widget.calendarStyle.headerMargin,
              onPressed: () => _setPage(page: 2),
              icon: Icon(
                Icons.keyboard_arrow_right,
                color: widget.calendarStyle.iconColor,
              ),
            ),
          ],
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: this._renderWeekDays(),
          ),
        ),
        Expanded(
          child: PageView.builder(
            itemCount: 3,
            onPageChanged: (value) {
              this._setPage(page: value);
            },
            controller: _pageCtrl,
            itemBuilder: (context, index) {
              return _buildCalendar(dict, index);
            },
          ),
        ),
      ],
    );
  }

  _buildCalendar(DateDict dict, int slideIndex) {
    int totalItemCount = DateTime(
          this._pageDates[slideIndex].year,
          this._pageDates[slideIndex].month + 1,
          0,
        ).day +
        this._startWeekday[slideIndex] +
        (7 - this._endWeekday[slideIndex]);
    int year = this._pageDates[slideIndex].year;
    int month = this._pageDates[slideIndex].month;

    List<Widget> children = [];

    DateTime startDate =
        DateTime(this._pageDates[slideIndex].year, this._pageDates[slideIndex].month, 1 - this._startWeekday[slideIndex]);

    DateTime endDate = DateTime(
        this._pageDates[slideIndex].year, this._pageDates[slideIndex].month, totalItemCount - this._startWeekday[slideIndex]);

    List<EventItem> thisMonth = [];

    for (EventItem item in widget.events) {
      if (item.matchDate(startDate, untilAnotherDate: endDate)) {
        thisMonth.add(item);
      }
    }

    if (_selectedDateTime.difference(startDate) >= Duration.zero && _selectedDateTime.difference(endDate) <= Duration.zero) {
      if (selectedDateEvents == null && _selectedDateTime != null && widget.onDayPressed != null) {
        List<EventItem> newEventItems = [];

        for (EventItem item in widget.events) {
          if (item.matchDate(_selectedDateTime)) {
            newEventItems.add(item);
          }
        }

        selectedDateEvents?.clear();
        selectedDateEvents = newEventItems;
      }

      int totalPortion = (selectedDateEvents?.length ?? 1).clamp(1, 5);

      for (int i = 0; i < (selectedDateEvents?.length ?? 0); i++) {
        double beginPortion = (i * (1.0 / totalPortion)).clamp(0.0, 0.8);
        double endPortion = ((i + 1) * (1.0 / totalPortion)).clamp(0.0, 1.0);

        Widget widget = SlideTransition(
            position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).animate(
              CurvedAnimation(
                parent: _listAnimation,
                curve: Interval(
                  beginPortion,
                  endPortion,
                  curve: Curves.ease,
                ),
              ),
            ),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _listAnimation,
                  curve: Interval(
                    0.0,
                    1.0,
                    curve: Curves.ease,
                  ),
                ),
              ),
              child: _buildEventCard(dict, selectedDateEvents[i]),
            ));

        children.add(widget);
      }
    }

    if (children.length == 0) {
      children.add(Center(child: Material(color: Colors.transparent, child: Text(dict.getString("no_event")))));
    }

    /// build calendar and marked dates notes
    return AdvColumn(
      children: <Widget>[
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          childAspectRatio: widget.calendarStyle.childAspectRatio,
          padding: EdgeInsets.zero,
          children: List.generate(totalItemCount, (index) {
            DateTime currentDate = DateTime(year, month, index + 1 - this._startWeekday[slideIndex]);
            bool isToday = DateTime.now().day == currentDate.day &&
                DateTime.now().month == currentDate.month &&
                DateTime.now().year == currentDate.year;
            bool isSelectedDay = _selectedDateTime == currentDate;

            bool isPrevMonthDay = index < this._startWeekday[slideIndex];
            bool isNextMonthDay = index >= (DateTime(year, month + 1, 0).day) + this._startWeekday[slideIndex];
            bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

            TextStyle textStyle;
            Color borderColor;
            if (isPrevMonthDay) {
              textStyle = isSelectedDay
                  ? widget.calendarStyle.defaultSelectedDayTextStyle
                  : widget.calendarStyle.defaultPrevDaysTextStyle;
              borderColor = widget.calendarStyle.prevMonthDayBorderColor;
            } else if (isThisMonthDay) {
              textStyle = isSelectedDay
                  ? widget.calendarStyle.defaultSelectedDayTextStyle
                  : isToday ? widget.calendarStyle.defaultTodayTextStyle : widget.calendarStyle.defaultDaysTextStyle;
              borderColor = isToday ? widget.calendarStyle.todayBorderColor : widget.calendarStyle.nextMonthDayBorderColor;
            } else if (isNextMonthDay) {
              textStyle = isSelectedDay
                  ? widget.calendarStyle.defaultSelectedDayTextStyle
                  : widget.calendarStyle.defaultNextDaysTextStyle;
              borderColor = widget.calendarStyle.nextMonthDayBorderColor;
            }

            Color boxColor;
            if (isSelectedDay && widget.calendarStyle.selectedDayButtonColor != null) {
              boxColor = widget.calendarStyle.selectedDayButtonColor;
            } else if (isToday && widget.calendarStyle.todayBorderColor != null) {
              boxColor = widget.calendarStyle.todayButtonColor;
            } else {
              boxColor = widget.calendarStyle.dayButtonColor;
            }

            int currentDateLong = currentDate.millisecondsSinceEpoch;
            int minDateLong = widget.minDateTime?.millisecondsSinceEpoch ?? currentDateLong;
            int maxDateLong = widget.maxDateTime?.millisecondsSinceEpoch ?? currentDateLong;
            bool availableDate = currentDateLong >= minDateLong && currentDateLong <= maxDateLong;
            TextStyle fixedTextStyle = (index % 7 == 0 || index % 7 == 6) && !isSelectedDay && !isToday
                ? widget.calendarStyle.defaultWeekendTextStyle
                : isToday ? widget.calendarStyle.defaultTodayTextStyle : textStyle;

            return Container(
              margin: EdgeInsets.all(widget.calendarStyle.dayPadding),
              child: IgnorePointer(
                ignoring: !availableDate,
                child: FlatButton(
                  color: availableDate ? boxColor : Color.lerp(systemGreyColor, boxColor, 0.8),
                  onPressed: () => _handleDayBoxTapped(currentDate),
                  padding: EdgeInsets.all(widget.calendarStyle.dayPadding),
                  shape: (widget.calendarStyle.daysHaveCircularBorder ?? false)
                      ? CircleBorder(side: BorderSide(color: borderColor))
                      : RoundedRectangleBorder(side: BorderSide(color: borderColor)),
                  child: Stack(children: <Widget>[
                    Center(
                      child: Text(
                        '${currentDate.day}',
                        style: availableDate
                            ? fixedTextStyle
                            : fixedTextStyle.copyWith(color: Color.lerp(systemGreyColor, fixedTextStyle.color, 0.5)),
                        maxLines: 1,
                      ),
                    ),
                    _renderMarked(thisMonth, currentDate),
                  ]),
                ),
              ),
            );
          }),
        ),
        Expanded(
          child: Hero(
            tag: "dailyDetail",
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
              child: SingleChildScrollView(
                  child:
                      AdvColumn(divider: ColumnDivider(8.0), margin: EdgeInsets.symmetric(vertical: 16.0), children: children)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(DateDict dict, EventItem item) {
    IconData icon;
    String text;

    switch (item.eventType) {
      case EventType.birthday:
        icon = Icons.cake;
        text = StringHelper.formatString(dict.getString("s_birthday"), {"{name}": "${item.name}"});
        break;
      case EventType.holiday:
        icon = Icons.flag;
        text = "${item.name}";
        break;
      case EventType.date:
        icon = Icons.group;
        text = "DATE : ${item.name}";
        break;
      case EventType.jpcc:
        icon = Icons.home;
        text = "JPCC : ${item.name}";
        break;
      case EventType.group:
        icon = Icons.group;
        text = "${dict.getString("group")} : ${item.name}";
        break;
      case EventType.personal:
        icon = Icons.person;
        text = "${dict.getString("personal")} : ${item.name}";
        break;
    }

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.0)),
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: AdvRow(children: [Expanded(child: Material(color: Colors.transparent, child: Text(text))), Icon(icon)]));
  }

  List<Widget> _renderWeekDays() {
    List<Widget> list = [];
    for (var weekDay in widget.calendarStyle.weekDays) {
      list.add(
        Expanded(
            child: Container(
          margin: widget.calendarStyle.weekDayMargin,
          child: Center(
            child: Text(
              weekDay,
              style: widget.calendarStyle.daysLabelTextStyle,
            ),
          ),
        )),
      );
    }
    return list;
  }

  /// draw a little dot inside the each boxes (only if it's one of the
  /// [widget.selectedDateEvents] and slightly below day text
  Widget _renderMarked(List<EventItem> monthlyEvents, DateTime now) {
    if (monthlyEvents != null && monthlyEvents.length > 0) {
      for (EventItem item in monthlyEvents) {
        if (item.matchDate(now)) return widget.calendarStyle.defaultMarkedDateWidget;
      }
    }

    return Container();
  }

  void _handleDayTitleTapped(BuildContext context) {
    /// unless the whole content is fully expanded, cannot tap on title
    if (widget.dayMonthAnim.value != 0.0) return;

    RenderBox fullRenderBox = context.findRenderObject();
    var fullSize = fullRenderBox.size;
    var fullOffset = Offset.zero;

    Rect fullRect = Rect.fromLTWH(fullOffset.dx, fullOffset.dy, fullSize.width, fullSize.height);
    Rect boxRect = widget.monthKey.currentState.getBoxRectFromIndex(this._pageDates[1].month - 1);

    rectTween = RectTween(begin: fullRect, end: boxRect);

    setState(() {
      widget.dayMonthAnim.forward();
    });
  }

  void _handleDayBoxTapped(DateTime currentDate) {
    /// unless the whole content is fully expanded, cannot tap on date
    if (widget.dayMonthAnim.value != 0.0) return;

    _selectedDateTime = currentDate;
    if (widget.onDayPressed != null) {
      List<EventItem> newEventItems = [];

      int counter = 0;
      for (EventItem item in widget.events) {
        if (item.matchDate(currentDate)) {
          newEventItems.add(item);
        }
        counter++;
      }

      selectedDateEvents?.clear();
      selectedDateEvents = newEventItems;
    }

    setState(() {
      _listAnimation.forward(from: 0.0);
    });

    widget.monthKey.currentState.updateSelectedDateTime(_selectedDateTime);
  }

  void _setPage({int page}) async {
    /// for initial set
    if (page == null) {
      DateTime date0 = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
      DateTime date1 = DateTime(DateTime.now().year, DateTime.now().month, 1);
      DateTime date2 = DateTime(DateTime.now().year, DateTime.now().month + 1, 1);
      DateTime date3 = DateTime(DateTime.now().year, DateTime.now().month + 2, 1);

      _startWeekday[0] = date0.weekday;
      _endWeekday[0] = date1.weekday;

      _startWeekday[1] = date1.weekday;
      _endWeekday[1] = date2.weekday;

      _startWeekday[2] = date2.weekday;
      _endWeekday[2] = date3.weekday;

      this.setState(() {
        this._pageDates = [
          date0,
          date1,
          date2,
        ];
      });
    } else if (page == 1) {
      /// return right away if the selected page is current page
      return;
    } else {
      /// processing for the next or previous page
      List<DateTime> dates = this._pageDates;

      /// previous page
      if (page == 0) {
        dates[2] = DateTime(dates[0].year, dates[0].month + 1, 1);
        dates[1] = DateTime(dates[0].year, dates[0].month, 1);
        dates[0] = DateTime(dates[0].year, dates[0].month - 1, 1);
        page = page + 1;
      } else if (page == 2) {
        /// next page
        dates[0] = DateTime(dates[2].year, dates[2].month - 1, 1);
        dates[1] = DateTime(dates[2].year, dates[2].month, 1);
        dates[2] = DateTime(dates[2].year, dates[2].month + 1, 1);
        page = page - 1;
      }

      DateTime _temp = DateTime(dates[2].year, dates[2].month + 1, 1);

      _startWeekday[0] = dates[0].weekday;
      _endWeekday[0] = dates[1].weekday;

      _startWeekday[1] = dates[page].weekday;
      _endWeekday[1] = dates[page + 1].weekday;

      _startWeekday[2] = dates[2].weekday;
      _endWeekday[2] = _temp.weekday;

      _pageCtrl.jumpToPage(page);
      int totalItemCount = DateTime(
            dates[page].year,
            dates[page].month + 1,
            0,
          ).day +
          this._startWeekday[page] +
          (7 - this._endWeekday[page]);

      DateTime startDate = DateTime(dates[page].year, dates[page].month, 1 - this._startWeekday[page]);

      DateTime endDate = DateTime(dates[page].year, dates[page].month, totalItemCount - this._startWeekday[page]);

      this.setState(() {
        this._pageDates = dates;
        if (!(_selectedDateTime.difference(startDate) >= Duration.zero &&
            _selectedDateTime.difference(endDate) <= Duration.zero)) {
          selectedDateEvents = null;
        }
      });
    }

    /// set current month and year in the [MonthCalendar] and
    /// [YearCalendar (via MonthCalendar)]
    widget.monthKey.currentState.setMonth(_pageDates[1].month, _pageDates[1].year);
    widget.monthKey.currentState.setYear(_pageDates[1].year);
  }

  /// an open method for [MonthCalendar] to trigger whenever it itself changes
  /// its month value
  void setMonth(
    int month,
    int year,
  ) {
    List<DateTime> dates = List(3);
    dates[0] = DateTime(year, month - 1, 1);
    dates[1] = DateTime(year, month, 1);
    dates[2] = DateTime(year, month + 1, 1);

    DateTime _temp = DateTime(dates[2].year, dates[2].month + 1, 1);

    _startWeekday[0] = dates[0].weekday;
    _endWeekday[0] = dates[1].weekday;

    _startWeekday[1] = dates[1].weekday;
    _endWeekday[1] = dates[2].weekday;

    _startWeekday[2] = dates[2].weekday;
    _endWeekday[2] = _temp.weekday;

    this.setState(() {
      this._pageDates = dates;
    });
  }

  void onFabTapped() {
    print("Event here!");
    if (this.mounted) {
      Routing.push(context, EventDetailPage(selectedDateEvents));
    }
  }
}

class MonthCalendar extends StatefulWidget {
  final BuildContext mainContext;
  final GlobalKey<DayCalendarState> dayKey;
  final GlobalKey<YearCalendarState> yearKey;
  final AnimationController dayMonthAnim;
  final AnimationController monthYearAnim;
  final CalendarStyle calendarStyle;
  final List<EventItem> events;
  final DateTime selectedDateTime;
  final Function(DateTime) onDayPressed;
  final DateTime minDateTime;
  final DateTime maxDateTime;

  MonthCalendar({
    this.mainContext,
    Key key,
    this.dayKey,
    this.yearKey,
    this.dayMonthAnim,
    this.monthYearAnim,
    this.calendarStyle,
    this.events,
    this.selectedDateTime,
    this.onDayPressed,
    this.minDateTime,
    this.maxDateTime,
  }) : super(key: key);

  @override
  MonthCalendarState createState() => MonthCalendarState();
}

class MonthCalendarState extends State<MonthCalendar> with TickerProviderStateMixin {
  /// The first run, this will be shown (0.0 [widget.dayMonthAnim]'s value)
  ///
  /// After the first run, when [widget.dayMonthAnim]'s value is 0.0, this will
  /// be gone
  ///
  /// When the [DayCalendar]'s title is tapped [_handleDayTitleTapped],
  /// we will give this the fade in animation ([widget.dayMonthAnim]'s value
  /// will gradually change from 0.0 to 1.0)
  ///
  /// When one of this' boxes is tapped [_handleMonthBoxTapped], we will give
  /// this the fade out animation ([widget.dayMonthAnim]'s value will gradually
  /// change from 1.0 to 0.0)
  ///
  /// When this title is tapped [_handleMonthTitleTapped],
  /// we will give this the fade out animation ([widget.monthYearAnim]'s value
  /// will gradually change from 1.0 to 0.0)
  ///
  /// When one of [YearCalendar]'s boxes is tapped [_handleYearBoxTapped],
  /// we will give this the fade in animation ([widget.monthYearAnim]'s value
  /// will gradually change from 0.0 to 1.0)

  /// Page Controller
  PageController _pageCtrl;

  /// Start Date from each page
  /// the selected page is on index 1,
  /// 0 is for previous year,
  /// 2 is for next year
  List<DateTime> _pageDates = List(3);

  /// Selected DateTime
  DateTime _selectedDateTime;

  /// Array for each boxes position and size
  ///
  /// each boxes position and size is stored for the first time and after they
  /// are rendered, since their size and position at full extension is always
  /// the same. Later will be used by [DayCalender] to squeezed its whole content
  /// as big as one of these boxes and in its position, according to its month
  /// value
  List<Rect> boxRects = List(12);

  /// Opacity controller for [MonthCalender]
  AnimationController opacityCtrl;

  /// Transition that this Widget will go whenever [DayCalendar]' title is tapped
  /// [_handleDayTitleTapped] or one of this' boxes is tapped [_handleMonthBoxTapped]
  ///
  /// or
  ///
  /// whenever this' title is tapped [_handleMonthTitleTapped] or one of
  /// [YearCalendar]'s boxes is tapped [_handleYearBoxTapped]
  ///
  /// This tween will always begin from one of [YearCalendar]'s boxes offset and size
  /// and end to full expanded offset and size
  Tween<Rect> rectTween;

  /// On the first run, [MonthCalendar] will need to be drawn so [boxRects] will
  /// be set
  bool _firstRun = true;

  @override
  initState() {
    super.initState();

    /// if the [pickType] is month, then show [MonthCalendar] as front page,
    /// (there will be no [DayCalendar], otherwise, hide [MonthCalendar] and
    /// wait until [DayCalendar] request to be shown
    ///
    /// See [_handleDayTitleTapped]
    opacityCtrl = AnimationController(duration: Duration(milliseconds: _kAnimationDuration), vsync: this);

    /// Change opacity controller's value equals month year controller's value
    widget.dayMonthAnim.addListener(() {
      opacityCtrl.value = widget.dayMonthAnim.value;
    });

    /// Whenever month to year animation is finished, reset rectTween to null
    /// Also change opacity controller's value equals month year controller's value
    widget.monthYearAnim.addListener(() {
      opacityCtrl.value = widget.monthYearAnim.value;

      if (widget.monthYearAnim.status == AnimationStatus.completed || widget.monthYearAnim.status == AnimationStatus.dismissed) {
        rectTween = null;
      }
    });

    _selectedDateTime = widget.selectedDateTime;

    /// setup pageController
    _pageCtrl = PageController(
      initialPage: 1,
      keepPage: true,
      viewportFraction: widget.calendarStyle.viewportFraction,
    );

    /// set _pageDates for the first time
    this._setPage();

    /// Switch firstRun's value to false after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _firstRun = false;
    });
  }

  @override
  dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext parentContext) {
    Widget monthContent = _buildMonthContent(parentContext);

    return AnimatedBuilder(
        animation: opacityCtrl,
        builder: (BuildContext context, Widget child) {
          if (rectTween == null)
            return AdvVisibility(
                visibility: opacityCtrl.value == 0.0 && !_firstRun ? VisibilityFlag.gone : VisibilityFlag.visible,
                child: Opacity(opacity: opacityCtrl.value, child: monthContent));

          /// rect tween set when one of these two occasions occurs
          /// 1. Month Title tapped so it has to be squeezed inside year boxes
          ///
          ///     See also [_handleMonthTitleTapped]
          /// 2. One of year boxes is tapped, so Month content should be expanded
          ///     See also [_handleMonthBoxTapped]

          /// calculate lerp of destination rect according to current
          /// widget.dayMonthAnim.value or widget.monthYearAnim.value
          final Rect destRect = rectTween.evaluate(opacityCtrl);

          /// minus padding for each horizontal and vertical axis
          final Size destSize = Size(destRect.size.width - (widget.calendarStyle.dayPadding * 2),
              destRect.size.height - (widget.calendarStyle.dayPadding * 2));
          final double top = destRect.top + widget.calendarStyle.dayPadding;
          final double left = destRect.left + widget.calendarStyle.dayPadding;

          double xFactor = destSize.width / rectTween.end.width;
          double yFactor = destSize.height / rectTween.end.height;

          final Matrix4 transform = Matrix4.identity()..scale(xFactor, yFactor, 1.0);

          /// For the Width and Height :
          /// keep the initial size, so we can achieve destination scale
          /// example :
          /// rectTween.end.width * destSize.width / rectTween.end.width => destSize.width

          /// For the Opacity :
          /// as the scaling goes from 0.0 to 1.0, we progressively change the opacity
          ///
          /// Note: to learn how these animations controller's value work,
          /// read the documentation at start of this State's script
          return Positioned(
              top: top,
              width: rectTween.end.width,
              height: rectTween.end.height,
              left: left,
              child: Opacity(opacity: opacityCtrl.value, child: Transform(transform: transform, child: monthContent)));
        });
  }

  _buildMonthContent(BuildContext parentContext) {
    return Column(
      children: <Widget>[
        AdvRow(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () => _setPage(page: 0),
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: widget.calendarStyle.iconColor,
              ),
            ),
            Builder(builder: (BuildContext childContext) {
              return Expanded(
                child: InkWell(
                  child: Container(
                    margin: widget.calendarStyle.headerMargin,
                    child: Text(
                      '${this._pageDates[1].year}',
                      textAlign: TextAlign.center,
                      style: widget.calendarStyle.defaultHeaderTextStyle,
                    ),
                  ),
                  onTap: () => _handleMonthTitleTapped(parentContext),
                ),
              );
            }),
            IconButton(
              onPressed: () => _setPage(page: 2),
              icon: Icon(
                Icons.keyboard_arrow_right,
                color: widget.calendarStyle.iconColor,
              ),
            ),
          ],
        ),
        Expanded(
          child: PageView.builder(
            itemCount: 3,
            onPageChanged: (value) {
              this._setPage(page: value);
            },
            controller: _pageCtrl,
            itemBuilder: (context, index) {
              return _buildCalendar(index);
            },
          ),
        ),
      ],
    );
  }

  _buildCalendar(int slideIndex) {
    int year = this._pageDates[slideIndex].year;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      childAspectRatio: widget.calendarStyle.childAspectRatio,
      padding: EdgeInsets.zero,
      children: List.generate(12, (index) {
        DateTime currentDate = DateTime(year, index + 1, 1);
        int currentDateInt = int.tryParse("$year${index + 1}");
        bool isToday = DateTime.now().month == currentDate.month && DateTime.now().year == currentDate.year;

        bool isSelectedDay = _selectedDateTime.month == currentDate.month && _selectedDateTime.year == currentDate.year;

        TextStyle textStyle;
        Color borderColor;

        Color boxColor;
        if (isSelectedDay) {
          textStyle = widget.calendarStyle.defaultSelectedDayTextStyle;
          boxColor = widget.calendarStyle.selectedDayButtonColor;
          borderColor = widget.calendarStyle.thisMonthDayBorderColor;
        } else if (isToday) {
          textStyle = widget.calendarStyle.defaultTodayTextStyle;
          boxColor = widget.calendarStyle.todayButtonColor;
          borderColor = widget.calendarStyle.todayBorderColor;
        } else {
          textStyle = widget.calendarStyle.defaultDaysTextStyle;
          boxColor = widget.calendarStyle.dayButtonColor;
          borderColor = widget.calendarStyle.thisMonthDayBorderColor;
        }

        return Builder(
          builder: (BuildContext context) {
            /// if [index]' boxRect is still null, set post frame callback to
            /// set boxRect after first render
            if (boxRects[index] == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                RenderBox renderBox = context.findRenderObject();
                RenderBox mainRenderBox = widget.mainContext.findRenderObject();
                var offset = renderBox.localToGlobal(Offset.zero, ancestor: mainRenderBox);
                var size = renderBox.size;
                Rect rect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
                boxRects[index] = rect;
              });
            }

            int currentDateLong = int.tryParse("${currentDate.year}${Utils.leadingZeroInt(currentDate.month, 2)}");
            int minDateLong = int.tryParse(
                "${widget.minDateTime?.year ?? currentDate.year}${Utils.leadingZeroInt(widget.minDateTime?.month ?? currentDate.month, 2)}");
            int maxDateLong = int.tryParse(
                "${widget.maxDateTime?.year ?? currentDate.year}${Utils.leadingZeroInt(widget.maxDateTime?.month ?? currentDate.month, 2)}");

            bool availableDate = currentDateLong >= minDateLong && currentDateLong <= maxDateLong;

            return Container(
              margin: EdgeInsets.all(widget.calendarStyle.dayPadding),
              child: IgnorePointer(
                ignoring: !availableDate,
                child: FlatButton(
                  color: availableDate ? boxColor : Color.lerp(systemGreyColor, boxColor, 0.8),
                  onPressed: () => _handleMonthBoxTapped(context, index + 1, year),
                  padding: EdgeInsets.all(widget.calendarStyle.dayPadding),
                  shape: (widget.calendarStyle.daysHaveCircularBorder ?? false)
                      ? CircleBorder(
                          side: BorderSide(color: borderColor),
                        )
                      : RoundedRectangleBorder(
                          side: BorderSide(color: borderColor),
                        ),
                  child: Center(
                    child: Text(
                      '${PitComponents.monthsArray[currentDate.month - 1]}',
                      style: availableDate
                          ? textStyle
                          : textStyle.copyWith(color: Color.lerp(systemGreyColor, textStyle.color, 0.5)),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _handleMonthTitleTapped(BuildContext context) {
    /// unless the whole content is fully expanded, cannot tap on title
    if (widget.monthYearAnim.value != 1.0) return;

    int yearMod = this._pageDates[1].year % 12;
    Rect boxRect = widget.yearKey.currentState.getBoxRectFromIndex((yearMod == 0 ? 12 : yearMod) - 1);

    RenderBox fullRenderBox = context.findRenderObject();
    var fullSize = fullRenderBox.size;
    var fullOffset = Offset.zero;

    Rect fullRect = Rect.fromLTWH(fullOffset.dx, fullOffset.dy, fullSize.width, fullSize.height);

    rectTween = RectTween(begin: boxRect, end: fullRect);

    setState(() {
      widget.monthYearAnim.reverse();
    });
  }

  void _handleMonthBoxTapped(BuildContext context, int month, int year) {
    /// unless the whole content is fully expanded, cannot tap on month
    if (widget.dayMonthAnim.value != 1.0 || widget.dayMonthAnim.status != AnimationStatus.completed) return;
    if (widget.monthYearAnim.value != 1.0 || widget.monthYearAnim.status != AnimationStatus.completed) return;

    DayCalendarState dayState = widget.dayKey.currentState;

    RenderBox monthBoxRenderBox = context.findRenderObject();
    Size monthBoxSize = monthBoxRenderBox.size;
    Offset monthBoxOffset = monthBoxRenderBox.localToGlobal(Offset.zero, ancestor: widget.mainContext.findRenderObject());
    Rect monthBoxRect = Rect.fromLTWH(monthBoxOffset.dx, monthBoxOffset.dy, monthBoxSize.width, monthBoxSize.height);

    RenderBox fullRenderBox = widget.mainContext.findRenderObject();
    var fullSize = fullRenderBox.size;
    var fullOffset = Offset.zero;
    Rect fullRect = Rect.fromLTWH(fullOffset.dx, fullOffset.dy, fullSize.width, fullSize.height);

    dayState.setState(() {
      dayState.setMonth(month, year);
      dayState.rectTween = RectTween(begin: fullRect, end: monthBoxRect);
      widget.dayMonthAnim.reverse();
    });
  }

  void _setPage({int page}) {
    /// for initial set
    if (page == null) {
      DateTime date0 = DateTime(DateTime.now().year - 1);
      DateTime date1 = DateTime(DateTime.now().year);
      DateTime date2 = DateTime(DateTime.now().year + 1);

      this.setState(() {
        this._pageDates = [
          date0,
          date1,
          date2,
        ];
      });
    } else if (page == 1) {
      /// return right away if the selected page is current page
      return;
    } else {
      /// processing for the next or previous page
      List<DateTime> dates = this._pageDates;

      /// previous page
      if (page == 0) {
        dates[2] = DateTime(dates[0].year + 1);
        dates[1] = DateTime(dates[0].year);
        dates[0] = DateTime(dates[0].year - 1);
        page = page + 1;
      } else if (page == 2) {
        /// next page
        dates[0] = DateTime(dates[2].year - 1);
        dates[1] = DateTime(dates[2].year);
        dates[2] = DateTime(dates[2].year + 1);
        page = page - 1;
      }

      this.setState(() {
        this._pageDates = dates;
      });

      /// animate to page right away after reset the values
      _pageCtrl.animateToPage(page, duration: Duration(milliseconds: 1), curve: Threshold(0.0));

      /// set year on [YearCalendar]
      widget.yearKey.currentState.setYear(_pageDates[1].year);
    }
  }

  /// an open method for [DayCalendar] to trigger whenever it itself changes
  /// its month value
  void setMonth(int month, int year) {
    List<DateTime> dates = List(3);
    dates[0] = DateTime(year, month - 1, 1);
    dates[1] = DateTime(year, month, 1);
    dates[2] = DateTime(year, month + 1, 1);

    this.setState(() {
      this._pageDates = dates;
    });
  }

  /// an open method for [DayCalendar] or [YearCalendar] to trigger whenever it
  /// itself changes its month value
  void setYear(int year) {
    List<DateTime> dates = List(3);
    int month = _pageDates[1].month;
    dates[0] = DateTime(year, month - 1, 1);
    dates[1] = DateTime(year, month, 1);
    dates[2] = DateTime(year, month + 1, 1);

    this.setState(() {
      this._pageDates = dates;
    });
  }

  void updateSelectedDateTime(DateTime selectedDateTime) {
    setState(() {
      _selectedDateTime = selectedDateTime;
    });

    widget.yearKey.currentState.updateSelectedDateTime(selectedDateTime);
  }

  /// get boxes size by index
  Rect getBoxRectFromIndex(int index) => boxRects[index];
}

class YearCalendar extends StatefulWidget {
  final BuildContext mainContext;
  final GlobalKey<MonthCalendarState> monthKey;
  final AnimationController monthYearAnim;
  final CalendarStyle calendarStyle;
  final List<EventItem> events;
  final DateTime selectedDateTime;
  final Function(DateTime) onDayPressed;
  final DateTime minDateTime;
  final DateTime maxDateTime;

  YearCalendar({
    this.mainContext,
    Key key,
    this.monthKey,
    this.monthYearAnim,
    this.calendarStyle,
    this.events,
    this.selectedDateTime,
    this.onDayPressed,
    this.minDateTime,
    this.maxDateTime,
  }) : super(key: key);

  @override
  YearCalendarState createState() => YearCalendarState();
}

class YearCalendarState extends State<YearCalendar> with SingleTickerProviderStateMixin {
  /// The first run, this will be hidden (1.0 [widget.monthYearAnim]'s value)
  ///
  /// When the [MonthCalendar]'s title is tapped [_handleMonthTitleTapped],
  /// we will give this the fade in animation ([widget.monthYearAnim]'s value
  /// will gradually change from 1.0 to 0.0)
  ///
  /// When one of this' boxes is tapped [_handleYearBoxTapped], we will give
  /// this the fade out animation ([widget.dayMonthAnim]'s value will gradually
  /// change from 0.0 to 1.0)
  ///
  PageController _pageCtrl;

  /// Start Date from each page
  /// the selected page is on index 1,
  /// 0 is for previous 12 years,
  /// 2 is for next 12 years
  List<DateTime> _pageDates = List(3);

  /// Selected DateTime
  DateTime _selectedDateTime;

  /// Array for each boxes position and size
  ///
  /// each boxes position and size is stored for the first time and after they
  /// are rendered, since their size and position at full extension is always
  /// the same. Later will be used by [MonthCalender] to squeezed its whole content
  /// as big as one of these boxes and in its position, according to its year
  /// value
  List<Rect> boxRects = List(12);

  /// Opacity controller for this
  ///
  /// This Opacity Controller is kinda different from [MonthCalendar]'s
  /// Since this AnimationController's value is reversed from [MonthCalendar]
  /// Explanation:
  /// [MonthCalendar.dayMonthAnim]'s 0.0 value would mean hidden for [MonthCalendar]
  /// and
  /// [MonthCalendar.dayMonthAnim]'s 1.0 value would mean shown for [MonthCalendar]
  ///
  /// therefore
  ///
  /// [MonthCalendar.opacityCtrl]'s 0.0 value would mean hidden for [MonthCalendar]
  /// and
  /// [MonthCalendar.opacityCtrl]'s 1.0 value would mean shown for [MonthCalendar]
  ///
  /// in order for [MonthCalendar]'s title can be tapped, it has to be in its full
  /// extension size ([MonthCalendar.opacityCtrl]'s 1.0 value) and when
  /// [MonthCalendar]'s title is tapped (_handleMonthTitleTapped), it has to reverse
  /// [MonthCalendar.opacityCtrl]'s value from 1.0 to 0.0, and if we link it to
  /// [MonthCalendar.monthYearCtrl] which is [this.monthYearCtrl] also,
  /// 0.0 would mean shown for this, thus, 1.0 would mean hidden.
  ///
  /// therefore
  ///
  /// this' opacity would be [1.0 - opacityCtrl.value]
  AnimationController opacityCtrl;

  @override
  initState() {
    super.initState();

    /// if the [pickType] is year, then show this as front page,
    /// (there will be no [DayCalendar] and [MonthCalendar], otherwise,
    /// hide this and wait until [MonthCalendar] request to be shown
    ///
    /// See [_handleMonthTitleTapped]
    opacityCtrl = AnimationController(duration: Duration(milliseconds: _kAnimationDuration), vsync: this, value: 1.0);

    /// Change opacity controller's value equals month year controller's value
    widget.monthYearAnim.addListener(() {
      opacityCtrl.value = widget.monthYearAnim.value;
    });

    _selectedDateTime = widget.selectedDateTime;

    /// setup pageController
    _pageCtrl = PageController(
      initialPage: 1,
      keepPage: true,
      viewportFraction: widget.calendarStyle.viewportFraction,

      /// width percentage
    );

    /// set _pageDates for the first time
    this._setPage();
  }

  @override
  dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ccontext) {
    return AnimatedBuilder(
        animation: opacityCtrl,
        builder: (BuildContext parentContext, Widget child) {
          /// this opacity is kinda different from [MonthCalendar]
          ///
          /// See [opacityCtrl]
          return Opacity(
            opacity: 1.0 - opacityCtrl.value,
            child: Column(
              children: <Widget>[
                Container(
                  margin: widget.calendarStyle.headerMargin,
                  child: DefaultTextStyle(
                    style: widget.calendarStyle.defaultHeaderTextStyle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => _setPage(page: 0),
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: widget.calendarStyle.iconColor,
                          ),
                        ),
                        Container(
                          child: Text(
                            '${this._pageDates[1].year + 1} - ${this._pageDates[1].year + 12}',
                          ),
                        ),
                        IconButton(
                          onPressed: () => _setPage(page: 2),
                          icon: Icon(
                            Icons.keyboard_arrow_right,
                            color: widget.calendarStyle.iconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    itemCount: 3,
                    onPageChanged: (value) {
                      this._setPage(page: value);
                    },
                    controller: _pageCtrl,
                    itemBuilder: (context, index) {
                      return _buildCalendar(index);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  _buildCalendar(int slideIndex) {
    int year = this._pageDates[slideIndex].year;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      childAspectRatio: widget.calendarStyle.childAspectRatio,
      padding: EdgeInsets.zero,
      children: List.generate(12, (index) {
        bool isToday = DateTime.now().year == year + index + 1;
        DateTime currentDate = DateTime(year + index + 1);
        bool isSelectedDay = _selectedDateTime.year == currentDate.year;

        TextStyle textStyle;
        Color borderColor;
        Color boxColor;
        if (isSelectedDay) {
          textStyle = widget.calendarStyle.defaultSelectedDayTextStyle;
          boxColor = widget.calendarStyle.selectedDayButtonColor;
          borderColor = widget.calendarStyle.thisMonthDayBorderColor;
        } else if (isToday) {
          textStyle = widget.calendarStyle.defaultTodayTextStyle;
          boxColor = widget.calendarStyle.todayButtonColor;
          borderColor = widget.calendarStyle.todayBorderColor;
        } else {
          textStyle = widget.calendarStyle.defaultDaysTextStyle;
          boxColor = widget.calendarStyle.dayButtonColor;
          borderColor = widget.calendarStyle.thisMonthDayBorderColor;
        }

        return Builder(builder: (BuildContext context) {
          /// if [index]' boxRect is still null, set post frame callback to
          /// set boxRect after first render
          if (boxRects[index] == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              RenderBox renderBox = context.findRenderObject();
              RenderBox mainRenderBox = widget.mainContext.findRenderObject();
              var offset = renderBox.localToGlobal(Offset.zero, ancestor: mainRenderBox);
              var size = renderBox.size;
              Rect rect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
              boxRects[index] = rect;
            });
          }

          bool availableDate = currentDate.year >= (widget.minDateTime?.year ?? currentDate.year) &&
              currentDate.year <= (widget.maxDateTime?.year ?? currentDate.year);

          TextStyle fixedTextStyle = isToday ? widget.calendarStyle.defaultTodayTextStyle : textStyle;

          return Container(
            margin: EdgeInsets.all(widget.calendarStyle.dayPadding),
            child: IgnorePointer(
              ignoring: !availableDate,
              child: FlatButton(
                color: availableDate ? boxColor : Color.lerp(systemGreyColor, boxColor, 0.8),
                onPressed: () => _handleYearBoxTapped(context, currentDate.year),
                padding: EdgeInsets.all(widget.calendarStyle.dayPadding),
                shape: (widget.calendarStyle.daysHaveCircularBorder ?? false)
                    ? CircleBorder(
                        side: BorderSide(color: borderColor),
                      )
                    : RoundedRectangleBorder(
                        side: BorderSide(color: borderColor),
                      ),
                child: Center(
                  child: Text(
                    "${currentDate.year}",
                    style: availableDate
                        ? fixedTextStyle
                        : fixedTextStyle.copyWith(color: Color.lerp(systemGreyColor, fixedTextStyle.color, 0.5)),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          );
        });
      }),
    );
  }

  void _handleYearBoxTapped(BuildContext context, int year) {
    /// unless the whole content is shown, cannot tap on year
    if (widget.monthYearAnim.value != 0.0 || widget.monthYearAnim.status != AnimationStatus.dismissed) return;

    MonthCalendarState monthState = widget.monthKey.currentState;

    RenderBox yearBoxRenderBox = context.findRenderObject();
    Size yearBoxSize = yearBoxRenderBox.size;
    Offset yearBoxOffset = yearBoxRenderBox.localToGlobal(Offset.zero, ancestor: widget.mainContext.findRenderObject());
    Rect yearBoxRect = Rect.fromLTWH(yearBoxOffset.dx, yearBoxOffset.dy, yearBoxSize.width, yearBoxSize.height);

    RenderBox fullRenderBox = widget.mainContext.findRenderObject();
    Offset fullOffset = Offset.zero;
    Size fullSize = fullRenderBox.size;
    Rect fullRect = Rect.fromLTWH(fullOffset.dx, fullOffset.dy, fullSize.width, fullSize.height);

    monthState.setState(() {
      monthState.setYear(year);
      monthState.rectTween = RectTween(begin: yearBoxRect, end: fullRect);
      widget.monthYearAnim.forward();
    });
  }

  void _setPage({int page}) {
    /// for initial set
    if (page == null) {
      int year = (DateTime.now().year / 12).floor();

      DateTime date0 = DateTime((year - 1) * 12);
      DateTime date1 = DateTime(year * 12);
      DateTime date2 = DateTime((year + 1) * 12);

      this.setState(() {
        this._pageDates = [
          date0,
          date1,
          date2,
        ];
      });
    } else if (page == 1) {
      /// return right away if the selected page is current page
      return;
    } else {
      /// processing for the next or previous page
      List<DateTime> dates = this._pageDates;

      /// previous page
      if (page == 0) {
        int year = (dates[0].year / 12).floor();
        dates[2] = DateTime((year + 1) * 12);
        dates[1] = DateTime(year * 12);
        dates[0] = DateTime((year - 1) * 12);
        page = page + 1;
      } else if (page == 2) {
        /// next page
        int year = (dates[2].year / 12).floor();
        dates[0] = DateTime((year - 1) * 12);
        dates[1] = DateTime(year * 12);
        dates[2] = DateTime((year + 1) * 12);
        page = page - 1;
      }

      this.setState(() {
        this._pageDates = dates;
      });

      /// animate to page right away after reset the values
      _pageCtrl.animateToPage(page, duration: Duration(milliseconds: 1), curve: Threshold(0.0));
    }
  }

  /// an open method for [MonthCalendar] to trigger whenever it itself changes
  /// its year value
  void setYear(int year) {
    int pageYear = (year / 12).floor();

    List<DateTime> dates = List(3);
    dates[0] = DateTime((pageYear - 1) * 12);
    dates[1] = DateTime(pageYear * 12);
    dates[2] = DateTime((pageYear + 1) * 12);

    this.setState(() {
      this._pageDates = dates;
    });
  }

  void updateSelectedDateTime(DateTime selectedDateTime) {
    setState(() {
      _selectedDateTime = selectedDateTime;
    });
  }

  /// get boxes size by index
  Rect getBoxRectFromIndex(int index) => boxRects[index];
}
