import 'package:best_flutter_ui_templates/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/model/users.dart';
import 'package:best_flutter_ui_templates/ModelView/db/database.dart';
import 'package:best_flutter_ui_templates/services/facenet.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/view/navigation_home_screen.dart';
import 'index.dart';
import 'package:provider/provider.dart';
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

class AuthActionButtonSignUp extends StatefulWidget {
  AuthActionButtonSignUp(this._initializeControllerFuture,
      {@required this.onPressed, @required this.isLogin});
  final Future _initializeControllerFuture;
  final Function onPressed;
  final bool isLogin;
  @override
  _AuthActionButtonSignUpState createState() => _AuthActionButtonSignUpState();
}

class _AuthActionButtonSignUpState extends State<AuthActionButtonSignUp> {
  // final _fullnameFocusNode = FocusNode();
  String user;
  String email;
  String password;
  String age;
  String country;
  String state;
  final String userText = "Enter full name";
  String emailText = "Email";
  String passwordText = "Password";
  String ageText = "Age";
  String countryText = "Country";
  String stateText = "State";
  String _text = "press start speaking";
  double _confidence = 1.0;
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = new stt.SpeechToText();
  }

  /// service injection
  final FaceNetService _faceNetService = FaceNetService();
  final DataBaseService _dataBaseService = DataBaseService();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
    String age = _birthdayTextEditingController.text;
    String country = _countryTextEditingController.text;
    String state = _stateTextEditingController.text;

    /// creates a new user in the 'database'
    await Provider.of<Users>(context, listen: false)
        .addUser(email, password, age, country, user, state);
    await _dataBaseService.saveData(
        user, password, predictedData, email, age, country, state);

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
              builder: (BuildContext context) => NavigationHomeScreen(
                    fullname: this.predictedUser.user,
                  )));
      //    builder: (BuildContext context) => NavigationHomeScreen()));
    } else {
      print(" WRONG PASSWORD!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: widget.isLogin ? Text('Sign Up') : Text('Sign up'),
      icon: Icon(Icons.camera_alt),
      // Provide an onPressed callback.
      onPressed: () async {
        try {
          // Ensure that the camera is initialized.
          await widget._initializeControllerFuture;
          // onShot event (takes the image and predict output)
          bool faceDetected = await widget.onPressed();

          Scaffold.of(context).showBottomSheet((context) => signSheet(context));
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
              !widget.isLogin
                  ? Container()
                  : Row(
                      children: [
                        Container(
                          width: 280,
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
                              hintText: 'fullname',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              labelText: 'Fullname',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
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
                              user = value;
                              print(user);
                            },
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.mic,
                            size: 22,
                            color: DesignCourseAppTheme.nearlyBlue,

                            //onTap: _listen,
                            /* _isListening ? Icons.mic : Icons.mic_none*/
                          ),

                          /* onPressed: _listen,*/
                        ),
                      ],
                    ),
              !widget.isLogin
                  ? Container()
                  : Row(
                      children: [
                        Container(
                          width: 280,
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
              !widget.isLogin
                  ? Container()
                  : Row(
                      children: [
                        Container(
                          width: 280,
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
              !widget.isLogin
                  ? Container()
                  : Row(
                      children: [
                        Container(
                          width: 280,
                          child: TextFormField(
                              controller: _birthdayTextEditingController,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                // border: new OutlinedBorder(borderSide: new BorderSide(color: DesignCourseAppTheme.nearlyBlue)),

                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: DesignCourseAppTheme.nearlyBlue,
                                ),
                                hintText: 'Enter your age',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                labelText: 'Age',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please a valid age';
                                }
                                if (int.parse(value) < 0) {
                                  return 'Please a valid age';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                age = value;
                                print(age);
                              },
                              keyboardType: TextInputType.number),
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
              !widget.isLogin
                  ? Container()
                  : Row(
                      children: [
                        Container(
                            width: 280,
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
              !widget.isLogin
                  ? Container()
                  : Row(
                      children: [
                        Container(
                            width: 280,
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
              widget.isLogin
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
