import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/cards/post_card.dart';
import 'package:date_app/cards/reminder_card.dart';
import 'package:date_app/cards/voting_card.dart';
import 'package:date_app/utilities/backend.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/notification_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:url_launcher/url_launcher.dart';

const double _kImageHeight = 194.0;

const List<String> _kGroupNames = [
  "Tukang We eL",
  "Tukang Main Gitar",
  "Tim Pembawa Makan 1",
  "Tim Pembawa Makan 2",
  "Tim Pembawa Makan 3",
  "Tim Heboh",
//  "Defiant Pit Bulls",
//  "Flying Predators",
//  "Crazy Zombies",
//  "Haunting Foxes",
//  "Brutal Giants",
//  "Potent Phantoms",
//  "Quick Crabs",
//  "Exalted Dogs",
//  "Clever Aces",
//  "Fearless Hammers",
//  "Strong Busters",
//  "Classic Kangaroos",
//  "Naughty Ninjas",
//  "Major Peacocks",
//  "Monstrous Squirrels",
//  "Golden Rhinos",
//  "Brute Dingos",
//  "Red Doves",
//  "Silver Spiders",
//  "White Martians",
];

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
    "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/vd.jpg?alt=media&token=d9a0cfde-9e67-4a87-9c14-cde841784ab4",
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateDict dict = DateDict.of(context);

    NotificationHelper.init(aaa: (int id, String title, String body, String payload) async {
      print("saya di luar");
      // display a dialog with the notification details, tap ok to go to another page
      showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(title),
          content: new Text(body),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text('Ok'),
              onPressed: () async {
//              Navigator.of(context, rootNavigator: true).pop();
//              await Navigator.push(
//                context,
//                new MaterialPageRoute(
//                  builder: (context) => new SecondScreen(payload),
//                ),
//              );
              },
            )
          ],
        ),
      );

//      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//          'your channel id', 'your channel name', 'your channel description',
//          importance: Importance.Max, priority: Priority.High);
//      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//      var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//      await FlutterLocalNotificationsPlugin()
//              .show(0, '1 plain title', ' 1 plain body', platformChannelSpecifics, payload: '2 item id 2');
    },
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage fired! => $message");
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.Max, priority: Priority.High);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await FlutterLocalNotificationsPlugin()
            .show(0, 'plain title', 'plain body', platformChannelSpecifics, payload: 'item id 2');
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch fired! => $message");
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume fired! => $message");
      },
      onTokenRefresh: (String token) {
        print("onTokenRefresh fired! => $token");
      },);

    return SafeArea(
      child: SingleChildScrollView(
          child: AdvColumn(
              onlyInner: false,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              divider: ColumnDivider(16.0),
              children: [
            FlatButton(
              child: Text("Generate Group"),
              onPressed: () async {
//                print("group total 1 => ${groups.length}");
//                var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//                    'your channel id', 'your channel name', 'your channel description',
//                    importance: Importance.Max, priority: Priority.High);
//                var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//                var platformChannelSpecifics = new NotificationDetails(
//                    androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//                await FlutterLocalNotificationsPlugin().show(
//                    0, 'plain title', 'plain body', platformChannelSpecifics,
//                    payload: 'item id 2');
//                print("group total 2 => ${groups.length}");

//                groups.clear();
//                _generateGroup();
//                print("group total => ${groups.length}");
              },
            ),
            VotingCard(
                coverImageUrl: CachedNetworkImage(imageUrl: imageUrls[3], fit: BoxFit.cover),
                voteItems: [
                  VotingItem(subject: "Apakah konten renungan Read to Hear membantu anda?", options: ["Ya", "Tidak"]),
                  VotingItem(
                    subject: "Dari sumber manakah anda membaca atau mendengarkan firman Tuhan?",
                    options: ["Alkitab buku", "Aplikasi Alkitab", "Youtube", "Langganan majalah", "Komsel"],
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
            PostCard(
                imageUrl: imageUrls[0],
                title: "Vision Day",
                subtitle: "29 Jan 2019",
                content: contents[0],
                actionName: "See on Instagram",
                actionCallback: () {
                  launch(links[0]);
                }),
            PostCard(
                imageUrl: imageUrls[1],
                title: "JPCC Worship - 盼望 / HOPE (Official Full Album Audio)",
                subtitle: "25 Jan 2019",
                content: contents[1],
                actionName: "Watch on Youtube",
                actionCallback: () {
                  launch(links[1]);
                }),
            VotingCard(
                coverImageUrl: CachedNetworkImage(imageUrl: imageUrls[2], fit: BoxFit.cover),
                voteItems: List.generate(
                    4,
                    (index) => VotingItem(
                        subject: "$index => ${names[Random().nextInt(19)]}",
                        options: List.generate(Random().nextInt(20), (index) => names[index]))),
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
            ReminderCard(
                imageUrl: imageUrls[4],
                title: "Men Hangout (TransformMe)",
                date: DateTime(2019, 2, 3, 15, 57),
                venue: "Wayang Bistro, The Kasablanka Lt. 3",
                content: contents[4]),
          ])),
    );
  }
}
