import 'package:date_app/utilities/pref_keys.dart';
import 'package:date_app/view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zefyr/zefyr.dart';

class NoteAddPage extends StatefulWidget {
  @override
  _NoteAddPageState createState() => _NoteAddPageState();
}

class _NoteAddPageState extends View<NoteAddPage> {
  final ZefyrController _controller = ZefyrController(NotusDocument());
  final FocusNode _focusNode = new FocusNode();
  bool _editing = true;

  @override
  Widget buildView(BuildContext context) {
    final theme = new ZefyrThemeData(
      indentSize: 8.0,
      toolbarTheme: ZefyrToolbarTheme.fallback(context).copyWith(
        color: Colors.grey.shade800,
        toggleColor: Colors.grey.shade900,
        iconColor: Colors.white,
        disabledIconColor: Colors.grey.shade500,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        elevation: 1.0,
        title: Text(dict.getString("add_note")),
        actions: [IconButton(icon: Icon(_editing ? Icons.check : Icons.edit), onPressed: () async {

          SharedPreferences prefs = await SharedPreferences.getInstance();

          String userId = prefs.getString(kUserId);

          DatabaseReference eventRef = FirebaseDatabase.instance.reference().child("notes/$userId").push();

          await eventRef.set({"json": _controller.document.toJson().toString()});

          print("_controller.document.toJson(); => ${_controller.document.toDelta().toJson()}");
          print("_controller.document.plain(); => ${_controller.document.toPlainText()}");
          setState(() {
            _editing = !_editing;
          });
        },)],
      ),
      body: ZefyrScaffold(
        child: ZefyrTheme(
          data: theme,
          child: ZefyrEditor(
            padding: EdgeInsets.all(16.0),
            controller: _controller,
            focusNode: _focusNode,
            enabled: _editing,
            imageDelegate: new CustomImageDelegate(),
            physics: ClampingScrollPhysics(),
          ),
        ),
      ),
    );
  }

//  Widget buildEditor() {
//
//    return ZefyrTheme(
//      data: theme,
//      child: ZefyrEditor(
//        controller: _controller,
//        focusNode: _focusNode,
//        imageDelegate: new CustomImageDelegate(),
//        physics: ClampingScrollPhysics(),
//      ),
//    );
//  }
}

/// Custom image delegate used by this example to load image from application
/// assets.
///
/// Default image delegate only supports [FileImage]s.
class CustomImageDelegate extends ZefyrDefaultImageDelegate {
  @override
  Widget buildImage(BuildContext context, String imageSource) {
    // We use custom "asset" scheme to distinguish asset images from other files.
    if (imageSource.startsWith('asset://')) {
      final asset = new AssetImage(imageSource.replaceFirst('asset://', ''));
      return new Image(image: asset);
    } else {
      return super.buildImage(context, imageSource);
    }
  }
}