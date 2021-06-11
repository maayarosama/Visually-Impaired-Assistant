//import 'package:best_flutter_ui_templates/ModelView/clothes_screen.dart';
import 'package:best_flutter_ui_templates/ModelView/clothes_screen.dart';
import 'package:best_flutter_ui_templates/ModelView/currency_screen.dart';
import 'package:best_flutter_ui_templates/ModelView/food_screen.dart';
import 'package:best_flutter_ui_templates/design_course_app_theme.dart';

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

//import 'Food_outputScreen.dart';

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
      "If you want to make any order, hold a long press on the screen ,and then speak your order.If you want to know what page you are on, double tap the screen.If you want to detect currency ,say currency.If you want to detect text on menus ,say menu. If you want the help page, say help.  If you want the settings page, say settings.If you want the home page,say home. If you want the about us page, say about.  If you want to sign out, say sign out. If you want to hear the instructions again, say instructions.";
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
        print("dd");
        _speech.listen(
          onResult: (val) => setState(() {
            _command = val.recognizedWords;
            _givecommand(_command);
          }),
        );
      } else {
        print("false");
        setState(() => _isListening = false);
        await _speech.stop();
      }
    }
  }

  void _givecommand(_command) {
    if (_command == "currency") {
      option = "gallery";
      this.setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetectMain(option: this.option),
            ));
      });
    } else if (_command == "menu") {
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
            appBar: AppBar(
                backgroundColor: CupertinoColors.darkBackgroundGray,
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    decoration: BoxDecoration(
                        color: CupertinoColors.darkBackgroundGray,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        border: Border.all(
                            width: 0.01, color: DesignCourseAppTheme.notWhite)),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25.0)),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 20,
                          height: 30,
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Home',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      letterSpacing: 0.27,
                      color: DesignCourseAppTheme.nearlyBlue,
                    ),
                  )
                ])),
            backgroundColor: CupertinoColors.darkBackgroundGray,
            body: Column(
              children: <Widget>[
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
                              _showChoiceDialogOCR(context);
                            },
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                child: Image.asset(
                                  'assets/images/download.png',
                                  width: 150,
                                  height: 250,
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
                              _showChoiceDialogClothes(context);
                              //_showChoiceDialogFood(context);
                            },
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                child: Image.asset(
                                  'assets/images/clothes.png',
                                  width: 150,
                                  height: 250,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
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
                              _showChoiceDialogCurrency(context);
                            },
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                child: Image.asset(
                                  'assets/images/money.jpg',
                                  width: 150,
                                  height: 250,
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
                              _showChoiceDialogFood(context);
                            },
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                child: Image.asset(
                                  'assets/images/food.png',
                                  width: 150,
                                  height: 250,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _showChoiceDialogCurrency(BuildContext context) {
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
                            builder: (context) =>
                                DetectMain(option: this.option),
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
                            builder: (context) =>
                                DetectMain(option: this.option),
                          ));
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showChoiceDialogFood(BuildContext context) {
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
                            builder: (context) =>
                                DetectFood(option: this.option),
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
                            builder: (context) =>
                                DetectFood(option: this.option),
                          ));
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showChoiceDialogOCR(BuildContext context) {
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

  Future<void> _showChoiceDialogClothes(BuildContext context) {
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
                            builder: (context) =>
                                ClothesScreen(option: this.option),
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
                            builder: (context) =>
                                ClothesScreen(option: this.option),
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
