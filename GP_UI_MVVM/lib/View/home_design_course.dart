import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';

import 'package:best_flutter_ui_templates/design_course/popular_course_list_view.dart';
import 'package:best_flutter_ui_templates/ModelView/edituser_screen.dart';
import 'package:best_flutter_ui_templates/view/feedback_screen.dart';
import 'package:best_flutter_ui_templates/view/index.dart';
import 'package:best_flutter_ui_templates/view/invite_friend_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/ModelView/ocr_screen.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'dart:async';

import 'package:best_flutter_ui_templates/view/help_screen.dart';

import 'package:best_flutter_ui_templates/view/settings.dart';

class DesignCourseHomeScreen extends StatefulWidget {
  final String fullname;
  const DesignCourseHomeScreen({Key key, @required this.fullname})
      : super(key: key);

  _DesignCourseHomeScreenState createState() =>
      _DesignCourseHomeScreenState(fullname: this.fullname);
}

class _DesignCourseHomeScreenState extends State<DesignCourseHomeScreen> {
  String fullname;

  _DesignCourseHomeScreenState({this.fullname});
  CategoryType categoryType = CategoryType.gallery;
  OCR ocr = new OCR();
  OCRscreen ocrs = new OCRscreen();
  VoiceController _voiceController;
  stt.SpeechToText _speech = stt.SpeechToText();
  Widget screenView;
  String option = '';

  bool _isListening = false;
  String _command;
  String resultText = "";
  String text = 'This is your home page';
  String _welcometext =
      "Hello, This is your home page. If you want instructions long press on the screen and say instructions.";
  String _instructions =
      "If you want to make any order, hold a long press on the screen ,and then speak your order.If you want to know what page you are on, double tap the screen.If you want camera ,say camera. If you want the help page, say help.  If you want the settings page, say settings.If you want the home page,say home. If you want the about us page, say about. If you want the feedback page, say feedback. If you want to edit in your profile, say edit. If you want to sign out, say sign out. If you want to hear the instructions again, say instructions.";
  void _playVoice() {
    _voiceController.init().then((_) {
      _voiceController.speak(
        text,
        VoiceControllerOptions(),
      );
    });
  }

  _givecommands() async {
    _voiceController.init().then((_) {
      _voiceController.speak(
        _welcometext,
        VoiceControllerOptions(),
      );
    });
  }

  void _comm() async {
    _isListening = false;
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onState: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _command = val.recognizedWords;
            _givecommand(_command);
          }),
        );
      } else {
        setState(() => _isListening = false);
        await _speech.stop();
      }
    }
  }

  void _givecommand(_command) {
    if (_command == "camera") {
      option = "camera";
      this.setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OCR(option: this.option),
            ));
      });
    } else if (_command == "help") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HelpScreen(),
          ),
        );
      });
    } else if (_command == "settings") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Settings(),
          ),
        );
      });
    } else if (_command == "sign out") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyindexApp(),
        ),
      );
    } else if (_command == "about") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Invite(),
          ),
        );
      });
    } else if (_command == "edit") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditUserScreen(),
          ),
        );
      });
    } else if (_command == "feedback") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeedbackScreen(),
          ),
        );
      });
    } else if (_command == "instructions") {
      _voiceController.init().then((_) {
        _voiceController.speak(
          _instructions,
          //VoiceControllerOptions(),
        );
      });
    }
  }

  @override
  void initState() {
    _voiceController = FlutterTextToSpeech.instance.voiceController();
    screenView = DesignCourseHomeScreen(
      fullname: this.fullname,
    );
    _speech = new stt.SpeechToText();
    _givecommands();
    super.initState();
  }

  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'User',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(16.0)),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: DesignCourseAppTheme.nearlyBlue,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                      border:
                          Border.all(color: DesignCourseAppTheme.nearlyBlue)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.white24,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                      onTap: () {
                        _showChoiceDialog(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 12, left: 18, right: 18),
                        child: Center(
                          widthFactor: 2.5,
                          child: Text(
                            'Upload',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                letterSpacing: 0.27,
                                color: DesignCourseAppTheme.nearlyWhite),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget getPopularCourseUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'User',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                letterSpacing: 0.27,
                color: DesignCourseAppTheme.nearlyBlue),
          ),
          Flexible(
            child: PopularCourseListView(
              callBack: () {
                //moveTo();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return AppBar(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      automaticallyImplyLeading: false,
      title: Text(
        'Home',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          letterSpacing: 0.27,
          color: DesignCourseAppTheme.nearlyBlue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onDoubleTap: () {
          _playVoice();
        },
        onLongPress: () {
          _comm();
        },
        child: Container(
          color: CupertinoColors.darkBackgroundGray,
          child: Scaffold(
            backgroundColor: CupertinoColors.darkBackgroundGray,
            body: Column(
              children: <Widget>[
                getAppBarUI(),
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(10.0)),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: DesignCourseAppTheme.nearlyWhite,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            border: Border.all(
                                color: DesignCourseAppTheme.nearlyWhite)),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: DesignCourseAppTheme.nearlyBlack,
                            onTap: () {
                              _showChoiceDialog(context);
                            },
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                child: Image.asset(
                                  'assets/images/download.png',
                                  width: 65,
                                  height: 75,
                                )),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: DesignCourseAppTheme.nearlyWhite,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            border: Border.all(
                                color: DesignCourseAppTheme.nearlyWhite)),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: DesignCourseAppTheme.nearlyBlack,
                            onTap: () {
                              _showChoiceDialog(context);
                            },
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                child: Image.asset(
                                  'assets/images/clothes.png',
                                  width: 65,
                                  height: 75,
                                )),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: DesignCourseAppTheme.nearlyWhite,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            border: Border.all(
                                color: DesignCourseAppTheme.nearlyWhite)),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: DesignCourseAppTheme.nearlyBlack,
                            onTap: () {
                              _showChoiceDialog(context);
                            },
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                child: Image.asset(
                                  'assets/images/money.jpg',
                                  width: 65,
                                  height: 75,
                                )),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: DesignCourseAppTheme.nearlyWhite,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            border: Border.all(
                                color: DesignCourseAppTheme.nearlyWhite)),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: DesignCourseAppTheme.nearlyBlack,
                            onTap: () {
                              _showChoiceDialog(context);
                            },
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                child: Image.asset(
                                  'assets/images/food.png',
                                  width: 65,
                                  height: 75,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: <Widget>[
                          Flexible(
                            child: getPopularCourseUI(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: CupertinoColors.lightBackgroundGray,
            title: Text("Upload from"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      option = "gallery";
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OCR(option: this.option),
                          ));
                    },
                  ),
                  Padding(padding: EdgeInsets.all(16.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      option = "camera";
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OCR(option: this.option),
                          ));
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

enum CategoryType {
  upload,
  gallery,
}
