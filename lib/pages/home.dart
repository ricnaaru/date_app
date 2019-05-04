import 'package:date_app/components/post_card.dart';
import 'package:date_app/models.dart';
import 'package:date_app/presenters/home_presenter.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_loading_with_barrier.dart';
import 'package:refresher/refresher.dart';

class HomePage extends StatefulWidget {
  final HomePresenter presenter;

  HomePage(this.presenter);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends View<HomePage> {
  HomePresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    _presenter = widget.presenter;
  }

  @override
  Widget buildView(BuildContext context) {
    List<NewsFeedModel> content = _presenter.newsFeed;

    return Refresher(
          onRefresh: () async {
            await _presenter.refreshFeed();
            await _presenter.refreshEvents();
          },
          child: AdvColumn(
              onlyInner: false,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              divider: ColumnDivider(16.0),
              children: content == null
                  ? []
                  : content.map((NewsFeedModel model) {
                      if (model.type == NewsFeedType.post) {
                        return PostCard(model: model);
                      } else {
                        return Container();
                      }
                    }).toList()),
    );
  }
}
