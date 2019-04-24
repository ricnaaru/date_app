import 'package:date_app/pages/home.dart';
import 'package:date_app/presenters/home.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart' as ts;
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_loading_with_barrier.dart';

class HomeContainerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeContainerPageState();
}

class _HomeContainerPageState extends View<HomeContainerPage>
    with TickerProviderStateMixin
    implements HomeInterface {
  HomePresenter _presenter;
  List<Widget> _children;
  int _currentIndex = 0;
  AnimationController _fabAnimation;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);

    _presenter = HomePresenter(context, this, interface: this);
    _fabAnimation = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  }

  @override
  Widget buildView(BuildContext context) {
    DateDict dict = DateDict.of(context);

    _children = [
      HomePage(_presenter),
      Center(child: Text("Event")),
    ];

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
            child: Icon(icon, color: CompanyColors.primary)),
      );
    };

    return Scaffold(
      body: SafeArea(
          child: AdvLoadingWithBarrier(
              content: _children[_currentIndex], isProcessing: isProcessing())), // new
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        // new
        currentIndex: _currentIndex,
        // new
        items: [
          bottomNavigatorGenerator(Icons.home, dict.getString("home")),
          bottomNavigatorGenerator(Icons.event, dict.getString("event")),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.event_note),
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    if (index == 1)
      _fabAnimation.forward();
    else
      _fabAnimation.reverse();

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void onDataRefreshed() {
    setState(() {});
  }
}
