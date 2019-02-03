import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/components/adv_countdown.dart';
import 'package:date_app/components/adv_dialog.dart';
import 'package:date_app/pages/voting_card.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/string_helper.dart';
import 'package:date_app/utilities/textstyles.dart' as ts;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:url_launcher/url_launcher.dart';

const double _kImageHeight = 194.0;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> contents = [
    "Volunteers are not paid not because they are worthless, rather because they are PRICELESS.  Thanking each one of you volunteers for SELFLESSLY loving and building the church of Jesus Christ. Let\u2019s shine ever brighter \ud83d\udcab\ud83e\udd29\ud83c\udf1f #jpccvd2019 #jpccbrighter2019",
    "Hope - is what motivates us to live each day and move forward. This first Mandarin album of JPCC Worship entitled 盼望 (HOPE), tells about Jesus Christ as the source of hope for human beings. The ten songs in the album are specially selected to deliver an inspiring message and a kind reminder to bless many people that Jesus is a living God and He is faithful until the end; that His love and presence in every season gives us hope and strength to live.\n\n© 2018 Insight Unlimited Publishing. All rights reserved. International copyright secured. Used by permission. Tel: +62 21 225 80 625 Email: publishing@insight-unlimited.com\n\nJPCC Worship Mandarin Album, “盼望” / “HOPE” is available on:\nSpotify - https://smarturl.it/JPCCWorshipSpotify\nJOOX - https://smarturl.it/JPCCWoshipJOOX\niTunes/Apple Music - http://smarturl.it/JPCCWorshipAppleM\nDeezer - http://smarturl.it/JPCCWorshipDeezer\nAnd all digital platforms.\n\nConnect with us:\nInstagram - https://www.instagram.com/jpccworship\nFacebook - https://www.facebook.com/jpccworship \nTwitter - https://twitter.com/jpccworship \nWebsite - https://www.jpccworship.com \n\nContact:\nworship@jpcc.org",
    "Jadi kita lagi rencanain mau outing ke mana imlek tahun ini, so guys take your time to help us to decice ya!",
    "Tidak terasa sudah 3 bulan kita menjalani Read to Hear bible, apabila kalian pernah mengikuti Plan tersebut, yuk ikut survey kita untuk memperlengkap Plan ini!",
    "Men Hangout adalah komunitas pria di JPCC. Kami percaya pria dipanggil dengan tujuan yang mulia untuk menjalankan kebenaran Tuhan dalam segala aspek kehidupan dan menjadi jawaban bagi orang-orang sekeliling mereka. Men Hangout terbuka untuk semua jemaat JPCC (termasuk non-DATE Member)."
  ];

  List<String> imageUrls = [
    "https://instagram.fcgk18-1.fna.fbcdn.net/vp/8d3a89eebc80ad613d3f366144712efb/5C5223E7/t51.2885-15/e15/s320x320/49637373_940295846360411_1653214208115393093_n.jpg?_nc_ht=instagram.fcgk18-1.fna.fbcdn.net&_nc_cat=111",
    "https://img.youtube.com/vi/cfNQKvKNNuA/mqdefault.jpg",
    "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
    "https://pbs.twimg.com/media/DXasWxyV4AA3sCD.jpg",
    "https://scontent-lax3-2.cdninstagram.com/vp/370f4cf3189eb23836d76c8c1285a0c0/5CC91118/t51.2885-15/e35/s480x480/46423159_1942878362686826_1543705136521682260_n.jpg?_nc_ht=scontent-lax3-2.cdninstagram.com"
  ];

  List<String> links = [
    "https://www.instagram.com/p/BtKU5CelRBX/?utm_source=ig_share_sheet&igshid=18y80rj1fqnuv",
    "https://www.youtube.com/watch?v=cfNQKvKNNuA"
  ];

  List<String> names = [
    "Roselyn Adger",
    "Susie Melody",
    "Shanice Conkle",
    "Mandie Coderre",
    "Sheri Wills",
    "Lyndsay Robb",
    "Jenee Helzer",
    "Dina Schmuck",
    "Jimmie Leroux",
    "Michaele Mohler",
    "Bennett Burciaga",
    "Sylvester Claybrook",
    "Cindie Clothier",
    "Karlene Stevens",
    "Richelle Manz",
    "Pedro Kurtz",
    "Tiera Packett",
    "Tai Wilding",
    "Marsha Dudney",
    "Jasmin Faison",
  ];

  @override
  Widget build(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return SafeArea(
      child: SingleChildScrollView(
          child: AdvColumn(
              onlyInner: false,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              divider: ColumnDivider(16.0),
              children: [
            VotingCard(
                coverImageUrl: CachedNetworkImage(
                    imageUrl: imageUrls[3], fit: BoxFit.cover),
                voteItems: [
                  VotingItem(
                      subject:
                          "Apakah konten renungan Read to Hear membantu anda?",
                      options: ["Ya", "Tidak"]),
                  VotingItem(
                    subject:
                        "Dari sumber manakah anda membaca atau mendengarkan firman Tuhan?",
                    options: [
                      "Alkitab buku",
                      "Aplikasi Alkitab",
                      "Youtube",
                      "Langganan majalah",
                      "Komsel"
                    ],
                    includeOther: true,
                  ),
                ],
                title: "How impactful is Read to Hear for you?",
                subtitle: contents[3],
                callback: (int page, String value) async {
                  bool f = value == null ? false : Random().nextBool();

                  print("1 page => $page, $value, $f");

                  if (!f)
                    showSnackBar(
                        context,
                        (value == null)
                            ? dict.getString("err_no_option_selected")
                            : "Somehow you're not qualified to do this, yet!");

                  return f;
                }),
            _buildPostCard(imageUrls[0], "Vision Day", "29 Jan 2019",
                contents[0], "See on Instagram", actionCallback: () {
              launch(links[0]);
            }),
            _buildPostCard(
                imageUrls[1],
                "JPCC Worship - 盼望 / HOPE (Official Full Album Audio)",
                "25 Jan 2019",
                contents[1],
                "Watch on Youtube", actionCallback: () {
              launch(links[1]);
            }),
            VotingCard(
                coverImageUrl: CachedNetworkImage(
                    imageUrl: imageUrls[2], fit: BoxFit.cover),
                voteItems: List.generate(
                    4,
                    (index) => VotingItem(
                        subject: "$index => ${names[Random().nextInt(19)]}",
                        options: List.generate(
                            Random().nextInt(20), (index) => names[index]))),
                title: "DATE Cempaka Putih 1 Outing",
                subtitle: contents[2],
                callback: (int page, String value) async {
                  bool f = value == null ? false : Random().nextBool();

                  print("1 page => $page, $value, $f");

                  if (!f)
                    showSnackBar(
                        context,
                        (value == null)
                            ? dict.getString("err_no_option_selected")
                            : "Somehow you're not qualified to do this, yet!");
                  return f;
                }),
            _buildReminderCard(
                context,
                imageUrls[4],
                "Men Hangout (TransformMe)",
                DateTime(2019, 2, 3, 15, 57),
                "Wayang Bistro, The Kasablanka Lt. 3",
                contents[4]),
          ])),
    );
  }

  Card _buildPostCard(String imageUrl, String title, String subtitle,
      String content, String actionName,
      {VoidCallback actionCallback}) {
    return Card(
        child: AdvColumn(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
          child: SizedBox(
            height: _kImageHeight,
            width: double.infinity,
            child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
          ),
        ),
        AdvColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            divider: ColumnDivider(16.0),
            margin: EdgeInsets.all(8.0),
            children: [
              AdvColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  divider: ColumnDivider(4.0),
                  margin:
                      EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 8.0),
                  children: [
                    Text(title, style: ts.h5),
                    Text(subtitle, style: ts.p4),
                  ]),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: handleEmoji(content),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Container(
                    child: Text(
                      actionName,
                      style: ts.h9.copyWith(color: Colors.blueAccent),
                    ),
                    padding: EdgeInsets.all(8.0),
                  ),
                  onTap: () {
                    if (actionCallback != null) actionCallback();
                  },
                ),
              ),
            ]),
      ], //0.725 | 0.75
    ));
  }

  Card _buildReminderCard(BuildContext context, String imageUrl, String title,
      DateTime date, String venue, String content) {
    DateDict dict = DateDict.of(context);
    DateFormat df = dict.getDateFormat("dd MMM yyyy HH:mm");

    return Card(
        child: AdvColumn(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
          child: SizedBox(
            height: _kImageHeight,
            width: double.infinity,
            child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
          ),
        ),
        AdvColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            divider: ColumnDivider(16.0),
            margin: EdgeInsets.all(8.0),
            children: [
              AdvColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  divider: ColumnDivider(4.0),
                  margin:
                      EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 8.0),
                  children: [
                    Text(title, style: ts.h5),
                    Text("${df.format(date)} WIB\n$venue", style: ts.p4),
                  ]),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: handleEmoji(content),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Container(
                    child: Text(
                      dict.getString("remind_me"),
                      style: ts.h9.copyWith(color: Colors.blueAccent),
                    ),
                    padding: EdgeInsets.all(8.0),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlarmDialog(date));
                  },
                ),
              ),
            ]),
      ], //0.725 | 0.75
    ));
  }
}

class AlarmDialog extends StatelessWidget {
  final DateTime alarmDate;

  AlarmDialog(this.alarmDate);

  @override
  Widget build(BuildContext context) {
    DateDict dict = DateDict.of(context);
    DateFormat df = dict.getDateFormat("dd MMM yyyy HH:mm");

    return AdvDialog(
      title: dict.getString("alarm_set"),
      content: AdvColumn(
          divider: ColumnDivider(8.0),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(text: dict.getString("alarm_set_info")),
                TextSpan(text: " ${df.format(alarmDate)} WIB", style: ts.h8)
              ]),
            ),
            AdvCountdown(futureDate: alarmDate),
            CachedNetworkImage(
                imageUrl:
                    "https://upload.wikimedia.org/wikipedia/commons/7/7a/Alarm_Clock_GIF_Animation_High_Res.gif"),
          ]),
    );
  }
}
