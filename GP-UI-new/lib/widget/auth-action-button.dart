import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/design_course/home_design_course.dart';
import 'package:best_flutter_ui_templates/model/users.dart';
import 'package:best_flutter_ui_templates/screens/db/database.dart';
//import 'package:best_flutter_ui_templates/pages/profile.dart';
import 'package:best_flutter_ui_templates/services/facenet.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/screens/navigation_home_screen.dart';
//import '../home.dart';
import 'package:best_flutter_ui_templates/screens/index.dart';
import 'package:provider/provider.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:best_flutter_ui_templates/model/user.dart';

class User {
  String user;
  String password;
  String email;
  String country;
  String birthday;
  String state;

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
  final _ageFocusNode = FocusNode();
  final _fullnameFocusNode = FocusNode();
  String fullname;
  String email;
  String password;
  int age;
  String country;
  String state;
  /*final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  
  final _countryFocusNode = TextEditingController();
  final _stateFocusNode = FocusNode();
  //final _form = GlobalKey<FormState>();*/
  var _addedUser = Userr(
    userid: null,
    email: '',
    password: '',
    country: '',
    state: '',
  );
  var _initValues = {
    'email': '',
    'password': '',
    'age': '',
    'country': '',
    'fullname': '',
    'state': '',
  };
  var _isInit = true;
  var _isLoading = false;
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
  String _text = '';
  double _confidence = 1.0;

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onState: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {}),
        );
      } else {
        setState(() => _isListening = false);
        _speech.stop();
      }
    }
  }

//compare between innit state de and the one in the comment

  final TextEditingController _userTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _emailTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _birthdayTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _countryTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _stateTextEditingController =
      TextEditingController(text: '');

  User predictedUser;

  Future _signUp(context) async {
    List predictedData = _faceNetService.predictedData;
    String user = _userTextEditingController.text;
    String password = _passwordTextEditingController.text;
    String email = _emailTextEditingController.text;
    String birthday = _birthdayTextEditingController.text;
    String country = _countryTextEditingController.text;
    String state = _stateTextEditingController.text;

    /// creates a new user in the 'database'
    await Provider.of<Users>(context, listen: false)
        .addUser(email, password, age, country, fullname, state);
    await _dataBaseService.saveData(
        user, password, predictedData, email, birthday, country, state);

    /// resets the face stored in the face net sevice
    this._faceNetService.setPredictedData(null);
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MyindexApp()));
  }

  Future _signIn(context) async {
    String password = _passwordTextEditingController.text;

    if (this.predictedUser.password == password) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => NavigationHomeScreen()));
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
      label: widget.isLogin ? Text('Sign in') : Text('Sign up'),
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
              }
            }
            Scaffold.of(context)
                .showBottomSheet((context) => signSheet(context));
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
              widget.isLogin && predictedUser != null
                  ? Container(
                      color: CupertinoColors.darkBackgroundGray,
                      child: Text(
                        'Welcome back, ' + predictedUser.user + '! 😄',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                  : widget.isLogin
                      ? Container(
                          color: CupertinoColors.darkBackgroundGray,
                          child: Text(
                            'User not found 😞',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ))
                      : Container(),
              widget.isLogin
                  ? Container()
                  : Row(
                      children: [
                        Container(
                            width: 330,
                            child: TextFormField(
                              controller: _userTextEditingController,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                // border: new OutlinedBorder(borderSide: new BorderSide(color: DesignCourseAppTheme.nearlyBlue)),

                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                icon: const Icon(
                                  Icons.person,
                                  color: DesignCourseAppTheme.nearlyBlue,
                                ),
                                hintText: 'Enter your Full name',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_fullnameFocusNode);
                              },
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please a valid Name';
                                }
                                if (!RegExp("^[a-zA]").hasMatch(value)) {
                                  return 'Please a valid Name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                fullname = value;
                                print("fullname is");
                                print(fullname);
                              },
                              keyboardType: TextInputType.text,
                            )),
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
              widget.isLogin
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
                            keyboardType: TextInputType.text,
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
              widget.isLogin
                  ? Container()
                  : Row(
                      children: [
                        Container(
                            width: 330,
                            child: TextFormField(
                              controller: _countryTextEditingController,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                // border: new OutlinedBorder(borderSide: new BorderSide(color: DesignCourseAppTheme.nearlyBlue)),

                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                icon: const Icon(
                                  Icons.location_on,
                                  color: DesignCourseAppTheme.nearlyBlue,
                                ),
                                hintText: 'Enter your country',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                labelText: 'Country',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please a valid Country';
                                }
                                if (!RegExp("^[a-zA]").hasMatch(value)) {
                                  return 'Please a valid Country';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                country = value;
                              },
                              keyboardType: TextInputType.text,
                            )),
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
              widget.isLogin
                  ? Container()
                  : Row(
                      children: [
                        Container(
                            width: 330,
                            child: TextFormField(
                              controller: _stateTextEditingController,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                // border: new OutlinedBorder(borderSide: new BorderSide(color: DesignCourseAppTheme.nearlyBlue)),

                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                icon: const Icon(
                                  Icons.location_city,
                                  color: DesignCourseAppTheme.nearlyBlue,
                                ),
                                hintText: 'Enter your State',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                labelText: 'State',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please a valid State';
                                }
                                if (!RegExp("^[a-zA]").hasMatch(value)) {
                                  return 'Please a valid State';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                state = value;
                              },
                              keyboardType: TextInputType.text,
                            )),
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
                            return NavigationHomeScreen();
                          }));
                        }
                        await _signIn(context);
                      },
                    )
                  : !widget.isLogin
                      ? RaisedButton(
                          child: Text(
                            'Sign Up!',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: DesignCourseAppTheme.nearlyBlue,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MyindexApp();
                              }));
                              await _signUp(context);
                            }
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
