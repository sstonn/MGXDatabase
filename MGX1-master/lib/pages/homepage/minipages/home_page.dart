import 'package:flutter/material.dart';
import 'package:loginandsignup/services/authentication.dart';
import 'package:loginandsignup/icons/customIcons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:loginandsignup/model/Item.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Item> items = List();
  Item item;
  DatabaseReference itemRef;

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference().child('items');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      form.reset();
      itemRef.push().set(item.toJson());
    }
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
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
            Color(0xFF1b1e44),
            Color(0xFF2d3447),
          ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomPadding: false,
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
              TextFormField(
                keyboardType: TextInputType.text,
                style: TextStyle(
                    fontFamily: "oscinebold",
                    fontSize: 16.0,
                    color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    FontAwesomeIcons.envelope,
                    color: Colors.white,
                    size: 22.0,
                  ),
                  hintText: "Email Address",
                  hintStyle: TextStyle(
                      fontFamily: "oscinebold",
                      fontSize: 17.0,
                      color: Colors.white30),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return value;
                  } else {
                    return null;
                  }
                },
                onSaved: (value) => item.title = value,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                style: TextStyle(
                    fontFamily: "oscinebold",
                    fontSize: 16.0,
                    color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    FontAwesomeIcons.envelope,
                    color: Colors.white,
                    size: 22.0,
                  ),
                  hintText: "Email Address",
                  hintStyle: TextStyle(
                      fontFamily: "oscinebold",
                      fontSize: 17.0,
                      color: Colors.white30),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return value;
                  } else {
                    return null;
                  }
                },
                onSaved: (value) => item.body = value,
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  handleSubmit();
                },
              ),
              Flexible(
                  child: FirebaseAnimatedList(
                    query: itemRef,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      return new ListTile(
                        leading: Icon(Icons.message),
                        title: Text(items[index].title),
                        subtitle: Text(items[index].body),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
