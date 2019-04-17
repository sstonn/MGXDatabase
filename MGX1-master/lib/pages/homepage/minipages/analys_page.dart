import 'package:flutter/material.dart';
import 'package:loginandsignup/services/authentication.dart';
import 'package:loginandsignup/icons/customIcons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
class MyAnalysPage extends StatefulWidget {
  MyAnalysPage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MyAnalysPageState();
}
class _MyAnalysPageState extends State<MyAnalysPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFF2d3247),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 30, 12, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        CustomIcons.menu,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {}),
                  Container(
                    child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.signOutAlt,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: () {
                          _signOut();
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Doanh thu hàng ngày",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: "oscinebold",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
