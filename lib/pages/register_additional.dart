import 'package:date_app/models.dart';
import 'package:date_app/presenters/register.dart';
import 'package:date_app/utilities/string_helper.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_list_tile.dart';
import 'package:pit_components/components/adv_row.dart';

class RegisterAdditionalPage extends StatefulWidget {
  final RegisterPresenter presenter;

  RegisterAdditionalPage({@required this.presenter});

  @override
  State<StatefulWidget> createState() => _RegisterAdditionalPageState();
}

class _RegisterAdditionalPageState extends View<RegisterAdditionalPage> {
  RegisterPresenter _presenter;

  @override
  void initState() {
    _presenter = widget.presenter;
    _presenter.additionalView = this;
    super.initState();
  }

  @override
  Widget buildView(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 32.0).copyWith(top: 0.0, bottom: 16.0),
        child: AdvColumn(
          divider: ColumnDivider(16.0),
          children: [
            Expanded(
              child: AdvColumn(
                divider: ColumnDivider(8.0),
                children: [
                  Container(height: 40.0),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: AdvRow(
                        divider: RowDivider(8.0),
                        children: [
                          AdvButtonWithIcon(
                              _presenter.college, Icon(Icons.add, size: 16.0), Axis.horizontal,
                              buttonSize: ButtonSize.small,
                              onPressed: _presenter.addCollegeInformation),
                          AdvButtonWithIcon(
                              _presenter.job, Icon(Icons.add, size: 16.0), Axis.horizontal,
                              buttonSize: ButtonSize.small,
                              onPressed: _presenter.addJobInformation),
                          AdvButtonWithIcon(
                              _presenter.business, Icon(Icons.add, size: 16.0), Axis.horizontal,
                              buttonSize: ButtonSize.small,
                              onPressed: _presenter.addBusinessInformation),
                        ],
                      )),
                  Expanded(
                      child: _presenter.occupations.length == 0
                          ? Center(
                              child: Text(
                              dict.getString("click_to_add_profession"),
                              textAlign: TextAlign.center,
                            ))
                          : SingleChildScrollView(
                              child: AdvColumn(
                                  divider: ColumnDivider(8.0),
                                  children: _presenter.occupations
                                      .map((occupation) => _buildOccupationItem(occupation))
                                      .toList()))),
                ],
              ),
            ),
            AdvButton(
              dict.getString("next"),
              width: double.infinity,
              onPressed: () {
                _presenter.nextPage();
              },
            ),
          ],
        ));
  }

  Widget _buildOccupationItem(OccupationModel model) {
    if (model is CollegeModel) {
      return _buildCollegeItem(model);
    } else if (model is JobModel) {
      return _buildJobItem(model);
    } else if (model is BusinessModel) {
      return _buildBusinessItem(model);
    }
  }

  Widget _buildCollegeItem(CollegeModel model) {
    DateFormat df = DateFormat("yyyy");

    return Container(
      child: AdvListTile(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          start: Icon(Icons.school),
          expanded: AdvColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
            model.major.isEmpty && model.degree.isEmpty
                ? null
                : Text(
                    "${model.major}${(model.degree).isEmpty ? "" : (model.major == null ? "" : " ") + "(${model.degree})"}",
                    style: h8),
            model.university.isEmpty ? null : Text(model.university),
            model.classYear == null
                ? null
                : Text("${dict.getString("class_year")}: ${df.format(model.classYear)}", style: p4),
            (model.semester == 0)
                ? null
                : Text(StringHelper.createOrdinalString(dict.locale, model.semester,
                    prefix: "Semester")),
          ])),
      color: Color.lerp(Colors.blue, Colors.white, 0.5),
    );
  }

  Widget _buildJobItem(JobModel model) {
    DateFormat df = dict.getDateFormat("MMM yyyy");

    return Container(
      child: AdvListTile(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          start: Icon(Icons.work),
          expanded: AdvColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
            model.jobTitle.isEmpty ? null : Text(model.jobTitle, style: h8),
            model.company.isEmpty && model.companyAddress.isEmpty
                ? null
                : Text.rich(TextSpan(children: [
              TextSpan(text: "${model.company}", style: h9),
              TextSpan(
                  text:
                  "${(model.companyAddress).isEmpty ? "" : (model.company == null ? "" : " ") + "(${model.companyAddress})"}"),
            ])),
            model.jobDescription.isEmpty ? null : Text(model.jobDescription, style: p4),
            model.since == null
                ? null
                : Text("${dict.getString("working_since")}: ${df.format(model.since)}"),
          ])),
      color: Color.lerp(Colors.blue, Colors.white, 0.5),
    );
  }

  Widget _buildBusinessItem(BusinessModel model) {
    DateFormat df = dict.getDateFormat("MMM yyyy");

    return Container(
      child: AdvListTile(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          start: Icon(Icons.directions_run),
          expanded: AdvColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
            model.businessName.isEmpty ? null : Text(model.businessName, style: h8),
            model.businessAddress.isEmpty ? null : Text(model.businessAddress, style: h8),
            model.businessDescription.isEmpty ? null : Text(model.businessDescription, style: p4),
            model.since == null
                ? null
                : Text("${dict.getString("open_since")}: ${df.format(model.since)}"),
          ])),
      color: Color.lerp(Colors.blue, Colors.white, 0.5),
    );
  }
}
