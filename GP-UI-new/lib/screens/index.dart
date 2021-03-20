//import 'package:best_flutter_ui_templates/pages/home.dart';
import 'package:best_flutter_ui_templates/screens/sign_up_screen.dart';
import 'package:best_flutter_ui_templates/screens/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navigation_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'package:best_flutter_ui_templates/screens/db/database.dart';
import 'package:best_flutter_ui_templates/screens/sign_in_screen.dart';
import 'package:best_flutter_ui_templates/screens/sign_up_screen.dart';
import 'package:best_flutter_ui_templates/services/facenet.service.dart';
import 'package:best_flutter_ui_templates/services/ml_vision_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/screens/admin_screen.dart';

class MyindexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Services injection
  VoiceController _voiceController;
  stt.SpeechToText _speech = stt.SpeechToText();
  Widget screenView;

  bool _isListening = false;
  String _command;
  String resultText = "";

  String _welcometext =
      "Hello, This is Blind assistant application. If you want to make any order, hold a long press on the screen ,and then speak your order. If you want to login in, say login.If you want to register,say register.";

  String _instructions = "";
  FaceNetService _faceNetService = FaceNetService();
  MLVisionService _mlVisionService = MLVisionService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  bool loading = false;
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
    if (_command == "login") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SignInPage(
              cameraDescription: cameraDescription,
            ),
          ),
        );
      });
    } else if (_command == "register") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MySignUpPage(
            cameraDescription: cameraDescription,
          ),
        ),
      );
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
    screenView = MyindexApp();
    _speech = new stt.SpeechToText();
    _givecommands();

    super.initState();
    _startUp();
  }

  /// 1 Obtain a list of the available cameras on the device.
  /// 2 loads the face net model
  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB();
    _mlVisionService.initialize();

    _setLoading(false);
  }

  // shows or hides the circular progress indicator
  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onLongPress: () {
          _comm();
        },
        child: Scaffold(
          backgroundColor: CupertinoColors.darkBackgroundGray,
          appBar: AppBar(
            backgroundColor: CupertinoColors.darkBackgroundGray,
            automaticallyImplyLeading: false,
            title: Text(
              'Blind Assitant',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                letterSpacing: 0.27,
                color: DesignCourseAppTheme.nearlyBlue,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.admin_panel_settings,
                  color: DesignCourseAppTheme.nearlyBlue,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Adminprofile();
                  }));
                },
              )
            ],
          ),
          body: !loading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppTheme.grey.withOpacity(0.6),
                                offset: const Offset(2.0, 4.0),
                                blurRadius: 8),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(60.0)),
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      RaisedButton(
                        color: DesignCourseAppTheme.nearlyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                        ),
                        child: Text(
                          'Sign In',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              letterSpacing: 0.27,
                              color: DesignCourseAppTheme.nearlyWhite),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => SignInPage(
                                cameraDescription: cameraDescription,
                              ),
                            ),
                          );
                        },
                      ),
                      RaisedButton(
                        color: DesignCourseAppTheme.nearlyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                        ),
                        child: Text(
                          'Sign Up',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              letterSpacing: 0.27,
                              color: DesignCourseAppTheme.nearlyWhite),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => MySignUpPage(
                                cameraDescription: cameraDescription,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      /*RaisedButton(
                    child: Text('Clean DB'),
                    onPressed: () {
                      _dataBaseService.cleanDB();
                    },
                  ),*/
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ],
      ),
    );
  }
}
