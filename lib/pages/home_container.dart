import 'package:date_app/pages/account.dart';
import 'package:date_app/pages/home.dart';
import 'package:date_app/pages/notification.dart';
import 'package:date_app/utilities/global.dart' as global;
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart' as ts;
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_state.dart';

class DateAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DateAppHomeState();
}

class _DateAppHomeState extends AdvState<DateAppHome> {
  GlobalKey _globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
  List<Widget> _children = [
    HomePage(),
    NotificationPage(),
    AccountPage(),
  ];
  int _currentIndex = 0;

  @override
  void initStateWithContext(BuildContext context) {
//    timeDilation = 5.0;
    super.initStateWithContext(context);
    DateDict dict = DateDict.of(context);
  }

  @override
  Widget advBuild(BuildContext context) {
    DateDict dict = DateDict.of(context);

    Function bottomNavigatorGenerator = (IconData icon, String title) {
      return BottomNavigationBarItem(
        icon: Container(
            height: 20.0,
            width: 20.0,
            margin: EdgeInsets.only(bottom: 3.0),
            child: Icon(icon, color: Colors.grey)),
        title: Text(title, style: ts.p4),
        activeIcon: Container(
            height: 20.0,
            width: 20.0,
            margin: EdgeInsets.only(bottom: 3.0),
            child: Icon(icon, color: global.systemPrimaryColor)),
      );
    };

    return Scaffold(
      body: new Container(
        child: _children[_currentIndex],
      ), // new
      bottomNavigationBar: BottomNavigationBar(
        key: _globalKey,
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        // new
        currentIndex: _currentIndex,
        // new
        items: [
          bottomNavigatorGenerator(Icons.home, dict.getString("home")),
          bottomNavigatorGenerator(
              Icons.notifications, dict.getString("notification")),
          bottomNavigatorGenerator(Icons.people, dict.getString("community")),
          bottomNavigatorGenerator(Icons.person, dict.getString("account")),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
