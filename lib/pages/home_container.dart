import 'package:date_app/application.dart';
import 'package:date_app/pages/event.dart';
import 'package:date_app/pages/home.dart';
import 'package:date_app/presenters/home_container.dart';
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
  AnimationController _fabAnimation;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);

    _presenter = HomePresenter(context, this);
    _fabAnimation = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    application.homeInterface = this;
  }

  @override
  Widget buildView(BuildContext context) {
    DateDict dict = DateDict.of(context);
    _children = [
      HomePage(_presenter),
      EventPage(_presenter),
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

    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primaryColorBrightness: Brightness.light,
        accentColorBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
            child: AdvLoadingWithBarrier(
                content: _children[_presenter.currentIndex],
                isProcessing: _presenter.newsFeed == null || _presenter.holidays == null || _presenter.events == null)), // new
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: _onTabTapped,
          // new
          currentIndex: _presenter.currentIndex,
          // new
          items: [
            bottomNavigatorGenerator(Icons.home, dict.getString("home")),
            bottomNavigatorGenerator(Icons.event, dict.getString("event")),
          ],
        ),
        floatingActionButton: ScaleTransition(
          scale: _fabAnimation,
          child: FloatingActionButton(
            onPressed: () {
              _presenter.onFabTapped();
            },
            child: Icon(Icons.event_note),
          ),
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
      _presenter.currentIndex = index;
    });
  }

  @override
  void onDataRefreshed() {
    setState(() {});
  }

  @override
  void resetEvents() {
    print("resetEvents");
    _presenter.refreshEvents();
  }
}

//import 'package:flutter/gestures.dart';
//import 'package:flutter/material.dart';
//
//class HomeContainerPage extends StatefulWidget {
//  @override
//  _ExState createState() => _ExState();
//}
//
//class _ExState extends State<HomeContainerPage> {
//
//  var xxt = TapGestureRecognizer()..onTap = () {
//    print("tap tap tap!");
//  };
//  @override
//  Widget build(BuildContext context) {
//    List<TextSpan> lts = [TextSpan(style: TextStyle(color: Color(0xff000000), fontSize: 14.0), text: "When Thor's evil brother, Loki (Tom Hiddleston), gains access to the unlimited power of the energy cube called the Tesseract, Nick Fury (Samuel L. Jackson), director of S.H.I.E.L.D., initiates a superhero recruitment effort to defeat the unprecedented threat to Earth. Joining Fury's \"dream team\" are Iron Man (Robert Downey Jr.), Captain America (Chris Evans), the Hulk (Mark Ruffalo), Thor (Chris Hemsworth), the Black Widow (Scarlett Johansson) and Hawkeye (Jeremy Renner)."),
//    TextSpan(style: TextStyle(color: Color(0xff2196f3)), recognizer: xxt, text: "https://www.youtube.com/watch?v=hA6hldpSTF8"),];
//
//    return Scaffold(body: RichText(
//      text: TextSpan(children: lts),
//      maxLines: 3,
//    ),);
//  }
//}
