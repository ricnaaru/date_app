import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart' as ts;
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_loading_with_barrier.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

const double _kImageHeight = 194.0;
const double _kCheckboxHeight = 28.0;
const String _waitingForResult =
    "http://piarea.co.id//assets/images/b41e1e27075137.5635f8edb514a%20(Behance).gif";
const String _sendingVote =
    "https://cdn.dribbble.com/users/114484/screenshots/3331928/submitting.gif";
const String _thankYou =
    "https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX27030027.jpg";
const String _kOtherValue = "[**OtherValue**]";

typedef VotingCardCallback = Future<bool> Function(
    int contentIndex, String value);

class VotingItem {
  final String subject;
  final List<String> options;
  final bool radioItem;
  final bool includeOther;
  final AdvTextFieldController otherController;
  final AdvTextFieldController chosenController;

  VotingItem({this.subject, this.options, bool radioItem, bool includeOther})
      : this.radioItem = radioItem ?? false,
        this.includeOther = includeOther ?? false,
        this.otherController = AdvTextFieldController(maxLines: 1),
        this.chosenController = AdvTextFieldController(maxLines: 1);
}

class VotingCard extends StatefulWidget {
  final Widget coverImageUrl;
  final List<VotingItem> voteItems;
  final String title;
  final String subtitle;
  final bool hasVoted;
  final VotingCardCallback callback;

  VotingCard(
      {this.coverImageUrl,
      this.voteItems,
      this.title,
      this.subtitle,
      bool hasVoted,
      this.callback})
      : this.hasVoted = hasVoted ?? false;

  @override
  State<StatefulWidget> createState() => _VotingCardState();
}

class _VotingCardState extends AdvState<VotingCard>
    with TickerProviderStateMixin {
  PageController _controller;
  int _page;
  AnimationController _wholeActionsCtrl;
  AnimationController _slideCtrl;
  AnimationController _cancelFadeCtrl;
  AnimationController _submitFadeCtrl;
  AnimationController _endingFadeCtrl;
  int _contentLength;
  List<VotingItem> _votingItems;

  int get _lastContentPage => _contentLength - 3;

  int get _pageBeforeLastContentPage => _contentLength - 4;

  @override
  void initState() {
    super.initState();

    _votingItems = widget.voteItems;
    _contentLength = _votingItems.length + 3;
    _page = widget.hasVoted ? _contentLength : 0;
    _controller =
        PageController(initialPage: widget.hasVoted ? _contentLength : 0);
    _wholeActionsCtrl =
        AnimationController(duration: kTabScrollDuration, vsync: this);
    _slideCtrl = AnimationController(
        duration: kTabScrollDuration,
        vsync: this,
        value: widget.hasVoted ? 1.0 : 0.0);
    _cancelFadeCtrl = AnimationController(
        duration: kTabScrollDuration,
        vsync: this,
        value: widget.hasVoted ? 1.0 : 0.0);
    _submitFadeCtrl = AnimationController(
        duration: kTabScrollDuration,
        vsync: this,
        value: widget.hasVoted ? 1.0 : 0.0);
    _endingFadeCtrl = AnimationController(
        duration: kTabScrollDuration,
        vsync: this,
        value: widget.hasVoted ? 1.0 : 0.0);

    _slideCtrl.addListener(() {
      _wholeActionsCtrl.value = _slideCtrl.value;
      if (_slideCtrl.status == AnimationStatus.completed ||
          _slideCtrl.status == AnimationStatus.dismissed) {
        setState(() {});
      }
    });

    _endingFadeCtrl.addListener(() {
      _wholeActionsCtrl.value = 1.0 - _endingFadeCtrl.value;

      if (_endingFadeCtrl.status == AnimationStatus.dismissed ||
          _endingFadeCtrl.status == AnimationStatus.forward) {
        setState(() {});
      }
    });
  }

  @override
  Widget advBuild(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return Card(
        child: AdvColumn(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
          child: SizedBox(
            height: _kImageHeight,
            width: double.infinity,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              children: [widget.coverImageUrl]
                ..addAll(_votingItems
                    .map((VotingItem item) => _buildContent(item))
                    .toList())
                ..add(_buildSubmittingContent())
                ..add(_buildThankYouContent())
                ..add(_buildFinalContent(dict)),
            ),
          ),
        ),
        AdvColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            divider: ColumnDivider(16.0),
            margin: EdgeInsets.all(8.0),
            children: [
              Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 8.0),
                  child: Text("${dict.getString("voting")}: ${widget.title}",
                      style: ts.h5)),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: handleEmoji(widget.subtitle),
              ),
              AdvLoadingWithBarrier(
                  barrierColor: Color(0x00000000),
                  content: DefaultTextStyle(
                    style: ts.h9.copyWith(color: Colors.blueAccent),
                    child: Stack(children: [
                      SlideTransition(
                        position: new Tween<Offset>(
                                begin: const Offset(-1.0, 0.0),
                                end: Offset.zero)
                            .animate(_slideCtrl),
                        child: FadeTransition(
                          opacity: Tween<double>(begin: 0.0, end: 1.0)
                              .animate(_wholeActionsCtrl),
                          child: AdvRow(
                            mainAxisAlignment: MainAxisAlignment.end,
                            divider: RowDivider(8.0),
                            children: [
                              InkWell(
                                child: Container(
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        FadeTransition(
                                          opacity: Tween<double>(
                                                  begin: 1.0, end: 0.0)
                                              .animate(_cancelFadeCtrl),
                                          child: Text(dict.getString("cancel")),
                                        ),
                                        FadeTransition(
                                          opacity: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(_cancelFadeCtrl),
                                          child: Text(dict.getString("back")),
                                        ),
                                      ]),
                                  padding: EdgeInsets.all(8.0),
                                ),
                                onTap: _handleBackTapped,
                              ),
                              InkWell(
                                child: Container(
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        FadeTransition(
                                          opacity: Tween<double>(
                                                  begin: 1.0, end: 0.0)
                                              .animate(_submitFadeCtrl),
                                          child: Text(dict.getString("next")),
                                        ),
                                        FadeTransition(
                                          opacity: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(_submitFadeCtrl),
                                          child: Text(dict.getString("submit")),
                                        ),
                                      ]),
                                  padding: EdgeInsets.all(8.0),
                                ),
                                onTap: _handleNextTapped,
                              ),
                            ],
                          ),
                        ),
                      ),
                      FadeTransition(
                          opacity: Tween<double>(begin: 1.0, end: 0.0)
                              .animate(_slideCtrl),
                          child: Visibility(
                            visible: _slideCtrl.value == 0.0,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                child: Container(
                                  child: Text(dict.getString("take_the_vote")),
                                  padding: EdgeInsets.all(8.0),
                                ),
                                onTap: _handleNextTapped,
                              ),
                            ),
                          )),
                      FadeTransition(
                          opacity: Tween<double>(begin: 0.0, end: 1.0)
                              .animate(_endingFadeCtrl),
                          child: Visibility(
                            visible: _endingFadeCtrl.value > 0.0,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  child: Text(
                                    dict.getString("thank_you_vote_submitted"),
                                    style: ts.h9.copyWith(
                                        color: systemDarkestGreyColor),
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                )),
                          ))
                    ]),
                  ),
                  isProcessing: isProcessing()),
            ]),
      ],
    ));
  }

  void _handleNextTapped() async {
    if (_page == 0) {
      _slideCtrl.forward();
    }

    if (_page == 1) {
      _cancelFadeCtrl.forward();
    }

    if (_page == _pageBeforeLastContentPage) {
      _submitFadeCtrl.forward();
    }

    if (widget.callback != null &&
        _page >= 1 &&
        _page <= _pageBeforeLastContentPage) {
      VotingItem currentItem = _votingItems[_page - 1];

      String value = currentItem.chosenController.text == _kOtherValue
          ? currentItem.otherController?.text
          : currentItem.chosenController.text;
      bool result = await widget.callback(_page - 1, value);

      if (!result) {
        if (_page == 1) {
          _cancelFadeCtrl.reverse();
        }
        if (_page == _pageBeforeLastContentPage) {
          _submitFadeCtrl.reverse();
        }
        return;
      }
    }

    if (_page == _lastContentPage) {
      bool result = false;
      await _nextPage();
      _wholeActionsCtrl.reverse();
      await process(() async {
        VotingItem currentItem = _votingItems[_lastContentPage - 1];
        String value = currentItem.chosenController.text == _kOtherValue
            ? currentItem.otherController?.text
            : currentItem.chosenController.text;
        await Future.delayed(Duration(milliseconds: 4000));
        result = await widget.callback(_lastContentPage - 1, value);

        if (!result) {
          _wholeActionsCtrl.forward();
          await _previousPage();
          return;
        }
      });

      if (!result) return;
      _endingFadeCtrl.forward();
      await _nextPage();
      await Future.delayed(Duration(milliseconds: 3000));
    }

    await _nextPage();
  }

  void _handleBackTapped() async {
    if (_page == 1) {
      _slideCtrl.reverse();
    }
    if (_page == 2) {
      _cancelFadeCtrl.reverse();
    }

    await _previousPage();
  }

  void _handleOptionTapped(VotingItem item, int currentIndex, String option) {
    setState(() {
      item.chosenController.text = option;
    });

    if (currentIndex != item.options.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(Duration(milliseconds: 300));
        if (currentIndex < item.options.length) _handleNextTapped();
      });
    }
  }

  Future<void> _nextPage() async {
    await _controller.nextPage(
        duration: kTabScrollDuration, curve: Curves.ease);
    _page = (_page + 1).clamp(0, _contentLength);
  }

  Future<void> _previousPage() async {
    await _controller.previousPage(
        duration: kTabScrollDuration, curve: Curves.ease);
    _page = (_page - 1).clamp(0, _contentLength);
  }

  Widget _buildFinalContent(DateDict dict) {
    return Stack(children: [
      CachedNetworkImage(imageUrl: _waitingForResult, fit: BoxFit.cover),
      Positioned(
          left: 16.0,
          bottom: 16.0,
          child: Container(
              width: 120.0,
              child: Text(
                dict.getString("computing_vote_info"),
                style: ts.h8.copyWith(color: Colors.black54),
                textAlign: TextAlign.center,
              )))
    ]);
  }

  Widget _buildSubmittingContent() {
    return CachedNetworkImage(imageUrl: _sendingVote, fit: BoxFit.cover);
  }

  Widget _buildThankYouContent() {
    return CachedNetworkImage(imageUrl: _thankYou, fit: BoxFit.cover);
  }

  Widget _buildContent(VotingItem item) {
    int _optionLength = item.options.length + ((item.includeOther) ? 1 : 0);

    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16.0),
        height: _kImageHeight,
        child: AdvColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            divider: ColumnDivider(8.0),
            children: [
              Text(item.subject, style: ts.h7),
              Expanded(child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                double remainingHeight = constraints.maxHeight;
                int crossAxisCount =
                    (remainingHeight / _kCheckboxHeight).floor();

                return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: AdvRow(
                        divider: RowDivider(16.0),
                        children: List.generate(
                            (_optionLength / crossAxisCount).ceil(), (index) {
                          return AdvColumn(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  List.generate(crossAxisCount, (columnIndex) {
                                int currentIndex =
                                    (index * crossAxisCount) + columnIndex;
                                if (currentIndex >= _optionLength) return null;

                                String option =
                                    currentIndex == item.options.length
                                        ? _kOtherValue
                                        : item.options[currentIndex];

                                AdvTextFieldController controller =
                                    item.otherController;

                                controller.enable =
                                    item.chosenController.text == option;

                                return InkWell(
                                  onTap: () {
                                    _handleOptionTapped(
                                        item, currentIndex, option);
                                  },
                                  child: Container(
                                      height: _kCheckboxHeight,
                                      child: AdvRow(
                                        divider: RowDivider(8.0),
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 18.0,
                                            height: 18.0,
                                            child: Checkbox(
                                              value:
                                                  item.chosenController.text ==
                                                      option,
                                              onChanged: (bool value) {
                                                _handleOptionTapped(
                                                    item, currentIndex, option);
                                              },
                                            ),
                                          ),
                                          currentIndex == item.options.length
                                              ? Container(
                                                  width: 100.0,
                                                  child: AdvTextField(
                                                    controller: controller,
                                                    textStyle: ts.p4,
                                                  ))
                                              : Text("$option", style: ts.p4)
                                        ],
                                      )),
                                );
                              }));
                        })));
              }))
            ]));
  }
}
