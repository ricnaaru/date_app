import 'package:date_app/components/daily_calendar_carousel.dart';
import 'package:date_app/models.dart';
import 'package:date_app/presenters/event.dart';
import 'package:date_app/presenters/home_container.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/pit_components.dart';

class EventPage extends StatefulWidget {
  final HomePresenter homePresenter;

  EventPage(this.homePresenter);

  @override
  State<StatefulWidget> createState() => EventPageState();
}

class EventPageState extends View<EventPage> {
  HomePresenter _homePresenter;
  EventPresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    _presenter = EventPresenter(context, this);
    _homePresenter = widget.homePresenter;
    _homePresenter.eventPresenter = _presenter;
  }

  @override
  Widget buildView(BuildContext context) {
    _presenter.events = _homePresenter.events;
    _presenter.birthdays = _homePresenter.birthdays;
    _presenter.holidays = _homePresenter.holidays;

    return SafeArea(
      child: DailyCalendarCarousel(
        minDateTime: DateTime(2019, 1, 1),
        maxDateTime: DateTime(2019, 12, 31),
        weekDays: PitComponents.weekdaysArray,
        checkMarkedCallback: _presenter.checkMarkedDate,
        onDayPressed: _presenter.onDayPressed,
        thisMonthDayBorderColor: Colors.grey,
        selectedDateTime: DateTime.now(),
        daysHaveCircularBorder: false,
      ),
    );
  }
}
