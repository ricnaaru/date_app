import 'package:date_app/components/daily_calendar_carousel.dart';
import 'package:date_app/models.dart';
import 'package:date_app/presenters/event.dart';
import 'package:date_app/presenters/home_presenter.dart';
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
    return SafeArea(
      child: DailyCalendarCarousel(
        minDateTime: DateTime(2019, 1, 1),
        maxDateTime: DateTime(2019, 12, 31),
        weekDays: PitComponents.weekdaysArray,
        checkMarkedCallback: (DateTime date, PickType type, {EventCategory category}) {
          return _presenter.checkMarkedDate(_homePresenter.events, date, type, category: category);
        },
        onDayPressed: (DateTime date) {
          return _presenter.onDayPressed(_homePresenter.events, date);
        },
        thisMonthDayBorderColor: Colors.grey,
        selectedDateTime: DateTime.now(),
        daysHaveCircularBorder: false,
      ),
    );
  }
}
