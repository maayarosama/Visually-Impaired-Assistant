import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:best_flutter_ui_templates/View/home_design_course.dart';
import 'package:best_flutter_ui_templates/ModelView/edituser_screen.dart';
import '../design_course_app_theme.dart';
import 'index.dart';
import 'invite_friend_screen.dart';
import 'settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  bool _isListening = false;
  String page = 'This is the help page';
  String _navigations =
      "The user will either login or sign up using face recognition. Then a directed audio will be played explaining to the user how to use voice commands, The voice commands executes specific actions, where the currency detection feature will be triggered when the user says currency,  The word clothes will trigger the color and pattern recognition feature. And Menu triggers the OCR feature,  The Food recognition feature will be triggered if the user says food then the user will capture image or choose image from gallery .  The image will be processed and the classified output will be converted to speech so the user can hear it. ";
  VoiceController _voiceController;
  stt.SpeechToText _speech = stt.SpeechToText();
  String _command;
  String resultText = "";

  @override
  void initState() {
    super.initState();
    _voiceController = FlutterTextToSpeech.instance.voiceController();
    _speech = stt.SpeechToText();
    _playsystemnavigations();
  }

  void _playsystemnavigations() {
    _voiceController.init().then((_) {
      _voiceController.speak(
        _navigations,
        VoiceControllerOptions(),
      );
    });
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
    if (_command == "about") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Invite(),
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
              appBar: AppBar(
                  backgroundColor: CupertinoColors.darkBackgroundGray,
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: CupertinoColors.darkBackgroundGray,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
                              border: Border.all(
                                  width: 0.01,
                                  color: DesignCourseAppTheme.notWhite)),
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
                          'Help',
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
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                        left: 16,
                        right: 16),
                    child: Image.asset(
                      'assets/images/helpImage.png',
                      height: 200,
                      width: 200,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    child: const Text(
                      'The user will either login or sign up using face recognition. Then a directed audio will be played explaining to the user how to use voice commands, The voice commands executes specific actions, where the currency detection feature will be triggered when the user says currency,  The word clothes will trigger the color and pattern recognition feature.  And  Menu triggers the OCR feature,  The Food recognition feature will be triggered if the user says food then the user will capture image or choose image from gallery .  The image will be processed and the classified output will be converted to speech so the user can hear it. ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
