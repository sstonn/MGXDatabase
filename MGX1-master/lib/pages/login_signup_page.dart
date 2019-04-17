import 'package:flutter/material.dart';
import 'package:loginandsignup/services/authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loginandsignup/loader/flip_loader.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({Key key,this.auth, this.userId,this.onSignedIn}): super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final String userId;
  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final FirebaseDatabase _database=FirebaseDatabase.instance;
  final _formKey = new GlobalKey<FormState>();
  StreamSubscription<Event> _onUserAddedSubscription;
  StreamSubscription<Event> _onUserChangedSubscription;
  Query _userQuery;
  String _email;
  String _password;
  String _errorMessage;
  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;
  // Initial form is login form
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        }

        setState(() {
          _isLoading = false;
        });
        if (userId.length > 0 && userId != null && _formMode == FormMode.LOGIN) {
          widget.onSignedIn();
        }

      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    }
  }


  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  /*_updateUser(user myuser){
    //Toggle completed
    if (myuser != null) {
      _database.reference().child("todo").child(myuser.key).set(myuser.toJson());
    }
  }*/

  /*_deleteUser(String userId, int index) {
    _database.reference().child("todo").child(userId).remove().then((_) {
      print("Delete $userId successful");
      setState(() {
        _userList.removeAt(index);
      });
    });
  }*/

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      colors: [
                      Color(0xFF3e6b8b),
                      Color(0xFF4c5e72),
                    ],
                      tileMode: TileMode.clamp
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 90.0),
            ),
            _showBody(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress(){
    if (_isLoading) {
      return Center(child: FlipLoader(loaderBackground: Color(0xFF212121),));
    } return Container(height: 0.0, width: 0.0,);

  }

  Widget _showBody(){
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showPrimaryButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.white,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/flutter-icon.png'),
        ),
      ),
    );
  }
  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(
          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
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
              fontFamily: "oscinebold", fontSize: 17.0,
              color: Colors.white30),
        ),
        validator: (value){
          if(value.isEmpty){
            _isLoading=false;
            return value;
          }else{
            _isLoading=false;
            return null;
          }
        },
        onSaved: (value)=>_email=value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(
          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
      child: TextFormField(
        obscureText: _obscureTextLogin,
        style: TextStyle(
            fontFamily: "oscinebold",
            fontSize: 16.0,
            color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            FontAwesomeIcons.lock,
            size: 22.0,
            color: Colors.white,
          ),
          hintText: "Password",
          hintStyle: TextStyle(
              fontFamily: "oscinebold",
              fontSize: 17.0,
              color: Colors.white30,
          ),
          suffixIcon: GestureDetector(
            onTap: _toggleLogin,
            child: Icon(
              FontAwesomeIcons.eye,
              size: 15.0,
              color: Colors.white,
            ),
          ),
        ),
        validator: (value){
          if(value.isEmpty){
            _isLoading=false;
            return value;
          }else{
            _isLoading=false;
            return null;
          }
        },
        onSaved: (value)=>_password=value,
      ),
    );
  }

  Widget _showPrimaryButton() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
       /* boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0xFF582841),
            offset: Offset(1.0, 6.0),
            blurRadius: 20.0,
          ),
          BoxShadow(
            color: Color(0xFFef4648),
            offset: Offset(1.0, 6.0),
            blurRadius: 20.0,
          ),
        ],*/
        gradient: new LinearGradient(
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF)
            ],
            begin: const FractionalOffset(0.2, 0.2),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: MaterialButton(
          highlightColor: Colors.transparent,
          splashColor: Color(0xFFef4648),
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 42.0),
            child: Text(
              "LOG IN",
              style: TextStyle(
                color: Color(0xFF212121),
                fontSize: 25.0,
                fontFamily: "oscinebold",),
            ),
          ),
          onPressed: () {
            _validateAndSubmit();
          }
      ),
    );
  }
  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}
