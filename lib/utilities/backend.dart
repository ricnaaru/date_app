import 'package:date_app/utilities/models.dart';
import 'package:flutter/material.dart';

class Backend {
  static void generateSchedule({
    String name,
    String description,
    String location,
    String startTime,
    String endTime,
    String type,
    List<Position> positions,
    bool shuffle,
    List<Availability> availabilities,
    List<DateTime> dates,
  }) {

  }

  static List<DateTime> getDates({String eventPeriod, int customDaysInterval, DateTime startDate, DateTime endDate}) {
    List<DateTime> dates = [startDate];
    int yearAddition = 0;
    int monthAddition = 0;
    int dayAddition = 0;

    switch (eventPeriod) {
      case 'daily':
        dayAddition = 1;
        break;
      case 'weekly':
        dayAddition = 7;
        break;
      case 'monthly':
        monthAddition = 1;
        break;
      case 'annual':
        yearAddition = 1;
        break;
      case 'custom':
        dayAddition = customDaysInterval;
        break;
    }

    DateTime runningDate = DateTime(
      startDate.year + yearAddition,
      startDate.month + monthAddition,
      startDate.day + dayAddition,
    );

    while (dayAddition + monthAddition + yearAddition > 0 && runningDate.compareTo(endDate) == -1) {
      dates.add(runningDate);

      runningDate = DateTime(
        runningDate.year + yearAddition,
        runningDate.month + monthAddition,
        runningDate.day + dayAddition,
      );
    }

    return dates;
  }
}
