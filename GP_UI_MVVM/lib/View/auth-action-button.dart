import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/design_course/home_design_course.dart';
import 'package:best_flutter_ui_templates/ModelView/db/database.dart';
import 'package:best_flutter_ui_templates/services/facenet.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/view/navigation_home_screen.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class User {
  String user;
  String password;
  String email;
  String country;
  String birthday;
  String state;
  String age;

  User(
      {@required this.user,
      @required this.password,
      @required this.email,
      @required this.country,
      @required this.birthday,
      @required this.state});

  static User fromDB(String dbuser) {
    return new User(
        user: dbuser.split(':')[0],
        password: dbuser.split(':')[1],
        email: dbuser,
        country: dbuser,
        birthday: dbuser,
        state: dbuser);
  }
}

class AuthActionButton extends StatefulWidget {
  AuthActionButton(this._initializeControllerFuture,
      {@required this.onPressed, @required this.isLogin});
  final Future _initializeControllerFuture;
  final Function onPressed;
  final bool isLogin;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  // final _fullnameFocusNode = FocusNode();
  String user;
  String email;
  String password;
  String age;
  String country;
  String state;

  @override
  void initState() {
    super.initState();
    _speech = new stt.SpeechToText();
  }

  /// service injection
  final FaceNetService _faceNetService = FaceNetService();
  final DataBaseService _dataBaseService = DataBaseService();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  //stt.SpeechToText _speech;
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _validate = false;

  bool _isListening = false;

//compare between innit state de and the one in the comment

  final TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _emailTextEditingController =
      TextEditingController(text: '');

  User predictedUser;

  Future _signIn(context) async {
    String password = _passwordTextEditingController.text;
    String email = _emailTextEditingController.text;

    if (this.predictedUser.password == password &&
        this.predictedUser.email == email) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => NavigationHomeScreen(
                    fullname: this.predictedUser.user,
                  )));
      //    builder: (BuildContext context) => NavigationHomeScreen()));
    } else {
      print(" WRONG PASSWORD!");
    }
  }

  String _predictUser() {
    String userAndPass = _faceNetService.predict();
    return userAndPass ?? null;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: widget.isLogin ? Text('Sign in') : Text('Sign In'),
      icon: Icon(Icons.camera_alt),
      // Provide an onPressed callback.
      onPressed: () async {
        try {
          // Ensure that the camera is initialized.
          await widget._initializeControllerFuture;
          // onShot event (takes the image and predict output)
          bool faceDetected = await widget.onPressed();

          if (faceDetected) {
            if (widget.isLogin) {
              var userAndPass = _predictUser();
              if (userAndPass != null) {
                this.predictedUser = User.fromDB(userAndPass);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DesignCourseHomeScreen(
                              fullname: this.predictedUser.user,
                            )));
              } else {
                Scaffold.of(context)
                    .showBottomSheet((context) => signSheet(context));
              }
            }
          }
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
    );
  }

  signSheet(context) {
    return Container(
      color: CupertinoColors.darkBackgroundGray,
      padding: EdgeInsets.all(20),
      height: 600,
      child: new Form(
          key: _formKey,
          child: Column(
            children: [
              widget.isLogin
                  ? Container(
                      color: CupertinoColors.darkBackgroundGray,
                      child: Text(
                        'User not found please enter email and password',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    )
                  : Container(),
              widget.isLogin && predictedUser == null
                  ? Container()
                  : Row(
                      children: [
                        Container(
                          width: 330,
                          child: TextFormField(
                            controller: _emailTextEditingController,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              // border: new OutlinedBorder(borderSide: new BorderSide(color: DesignCourseAppTheme.nearlyBlue)),

                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              icon: const Icon(
                                Icons.email,
                                color: DesignCourseAppTheme.nearlyBlue,
                              ),
                              hintText: 'Enter a email address',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please a valid email address';
                              }
                              if (!RegExp(
                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                  .hasMatch(value)) {
                                return 'Please a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              email = value;
                              print(email);
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.mic,
                            size: 22,
                            color: DesignCourseAppTheme.nearlyBlue,
                            /* _isListening ? Icons.mic : Icons.mic_none*/
                          ),

                          /* onPressed: _listen,*/
                        ),
                      ],
                    ),
              widget.isLogin && predictedUser == null
                  ? Container()
                  : Row(
                      children: [
                        Container(
                          width: 330,
                          child: TextFormField(
                            controller: _passwordTextEditingController,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              // border: new OutlinedBorder(borderSide: new BorderSide(color: DesignCourseAppTheme.nearlyBlue)),

                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              icon: const Icon(
                                Icons.lock,
                                color: DesignCourseAppTheme.nearlyBlue,
                              ),
                              hintText: 'Enter password',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please a valid password';
                              }
                              if (!RegExp("^[a-zA-Z0-9+_.-]").hasMatch(value)) {
                                return 'Please a valid password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              password = value;
                            },
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.mic,
                            size: 22,
                            color: DesignCourseAppTheme.nearlyBlue,
                            /* _isListening ? Icons.mic : Icons.mic_none*/
                          ),

                          /* onPressed: _listen,*/
                        ),
                      ],
                    ),
              widget.isLogin && predictedUser != null
                  ? RaisedButton(
                      color: DesignCourseAppTheme.nearlyBlue,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return NavigationHomeScreen(
                                fullname: this.predictedUser.user);
                          }));
                        }
                        await _signIn(context);
                      },
                    )
                  : Container(),
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
