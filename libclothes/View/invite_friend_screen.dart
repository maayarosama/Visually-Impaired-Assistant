import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/View/home_design_course.dart';
import 'package:best_flutter_ui_templates/ModelView/edituser_screen.dart';
import 'feedback_screen.dart';
import 'help_screen.dart';
import 'index.dart';
import 'settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Invite extends StatefulWidget {
  @override
  _InviteState createState() => _InviteState();
}

class _InviteState extends State<Invite> {
  bool _isListening = false;
  String page = 'This page is about our application';
  VoiceController _voiceController;
  stt.SpeechToText _speech = stt.SpeechToText();
  String _command;
  String resultText = "";
  @override
  void initState() {
    super.initState();
    _voiceController = FlutterTextToSpeech.instance.voiceController();
    _speech = stt.SpeechToText();
  }

  void _playVoice() {
    _voiceController.init().then((_) {
      _voiceController.speak(
        page,
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
    if (_command == "help") {
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
    } else if (_command == "home") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DesignCourseHomeScreen(),
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
    } else if (_command == "edit") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditUserScreen(),
          ),
        );
      });
    }
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
        child: new Container(
          color: CupertinoColors.darkBackgroundGray,
          child: SafeArea(
            top: false,
            child: Scaffold(
              backgroundColor: CupertinoColors.darkBackgroundGray,
              appBar: AppBar(
                backgroundColor: CupertinoColors.darkBackgroundGray,
                automaticallyImplyLeading: false,
                title: Text(
                  'About Us',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.nearlyBlue,
                  ),
                ),
              ),
              body: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                        left: 16,
                        right: 16),
                    child: Image.asset('assets/images/inviteImage.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    child: const Text(
                      'Are you one of those who makes everything\n at the last moment?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: DesignCourseAppTheme.nearlyWhite,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            color: DesignCourseAppTheme.nearlyBlue,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.6),
                                  offset: const Offset(4, 4),
                                  blurRadius: 8.0),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.share,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'Share',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
