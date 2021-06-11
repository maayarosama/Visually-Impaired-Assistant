import 'dart:async';
import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:app_settings/app_settings.dart';
import 'package:best_flutter_ui_templates/View/home_design_course.dart';
import 'package:best_flutter_ui_templates/ModelView/edituser_screen.dart';
import 'help_screen.dart';
import 'index.dart';
import 'invite_friend_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/design_course_app_theme.dart';
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() => runApp(Settings());

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isListening = false;
  String page = 'This is the settings page';
  VoiceController _voiceController;
  stt.SpeechToText _speech = stt.SpeechToText();
  String _command;
  String resultText = "";

  @override
  void initState() {
    initPlatformState();
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
    } else if (_command == "about") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Invite(),
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

  Future<void> initPlatformState() async {
    if (!mounted) return;
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
        child: new Scaffold(
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
                  'Settings',
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
          body: ListView(
            padding: const EdgeInsets.only(top: 8, left: 10),
            children: <Widget>[
              GestureDetector(
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: DesignCourseAppTheme.nearlyBlue,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Text(
                        'Security',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.27,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  AppSettings.openSecuritySettings();
                },
              ),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(
                      Icons.settings_applications,
                      color: DesignCourseAppTheme.nearlyBlue,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Text(
                        'Application settings',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.27,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  AppSettings.openAppSettings();
                },
              ),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(Icons.settings_display,
                        color: DesignCourseAppTheme.nearlyBlue),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Text(
                        'Display',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.27,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  AppSettings.openDisplaySettings();
                },
              ),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: DesignCourseAppTheme.nearlyBlue,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Text(
                        'Notifications',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.27,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  AppSettings.openNotificationSettings();
                },
              ),
              GestureDetector(
                child: Row(
                  children: [
                    Icon(
                      Icons.volume_up,
                      color: DesignCourseAppTheme.nearlyBlue,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Text(
                        'Sound',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.27,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  AppSettings.openSoundSettings();
                },
              ),
            ],
          ),
        ));
  }

  /// Dispose method to close out and cleanup objects.
  @override
  void dispose() {
    super.dispose();
  }
}
