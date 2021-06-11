import 'dart:io';
import 'package:best_flutter_ui_templates/View/home_design_course.dart';
import 'package:best_flutter_ui_templates/design_course_app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DetectMain extends StatefulWidget {
  final String option;
  const DetectMain({Key key, @required this.option}) : super(key: key);
  @override
  _DetectMainState createState() => new _DetectMainState(option: this.option);
}

class _DetectMainState extends State<DetectMain> with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  String option;
  bool isVisible = true;
  _DetectMainState({this.option});
  String rectext;

  final FlutterTts flutterTts = FlutterTts();

  File _image;
  double _imageWidth;
  double _imageHeight;
  var _recognitions;
  speak(String str) async {
    setState(() {
      isVisible = false;
    });
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(str);
  }

  Future<void> setScreen() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  stopSpeaker() async {
    setState(() {
      isVisible = true;
    });
    await flutterTts.stop();
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      res = await Tflite.loadModel(
        model: "assets/modelMobNet.tflite",
        labels: "assets/labels.txt",
      );
      print(res);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  void check() {
    if (option == "camera") {
      print(option);
      selectFromCamera();
    } else
      print(option);
    selectFromGallery();
  }

  // run prediction using TFLite on given image
  Future predict(File image) async {
    var recognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 255.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.5, // defaults to 0.1
        asynch: true // defaults to true
        );

    print(recognitions);

    setState(() {
      _recognitions = recognitions;
      rectext = _recognitions[0]['label'].toString().toUpperCase();
      print(rectext);
      speak(rectext);
    });
  }

  // send image to predict method selected from gallery or camera
  sendImage(File image) async {
    if (image == null) return;
    await predict(image);

    // get the width and height of selected image
    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
            _image = image;
          });
        })));
  }

  // select image from gallery
  selectFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {});
    sendImage(image);
  }

  // select image from camera
  selectFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {});
    sendImage(image);
  }

  @override
  void initState() {
    check();
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setScreen();
    loadModel().then((val) {
      setState(() {});
    });
  }

  Widget printValue(rcg) {
    if (rcg == null) {
      return Text('',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700));
    } else if (rcg.isEmpty) {
      return Center(
        child: Text("Could not recognize",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
      );
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Center(
        child: Text(
          "Prediction: " + _recognitions[0]['label'].toString().toUpperCase(),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            //backgroundColor: Colors.white,
            fontSize: 22,
            letterSpacing: 0.27,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // gets called every time the widget need to re-render or build
  @override
  Widget build(BuildContext context) {
    // get the width and height of current screen the app is running on
    Size size = MediaQuery.of(context).size;

    // initialize two variables that will represent final width and height of the segmentation
    // and image preview on screen
    double finalW;
    double finalH;

    // when the app is first launch usually image width and height will be null
    // therefore for default value screen width and height is given
    if (_imageWidth == null && _imageHeight == null) {
      finalW = size.width;
      finalH = size.height;
    } else {
      // ratio width and ratio height will given ratio to
//      // scale up or down the preview image
      double ratioW = size.width / _imageWidth;
      double ratioH = size.height / _imageHeight;

      // final width and height after the ratio scaling is applied
      finalW = _imageWidth * ratioW * .85;
      finalH = _imageHeight * ratioH * .50;
    }

    return GestureDetector(
      child: Scaffold(
          backgroundColor: CupertinoColors.darkBackgroundGray,
          body: Stack(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2.1,
              width: MediaQuery.of(context).size.width / 0.5,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: _image == null
                    ? Center(
                        child: Text("Select image from camera or gallery"),
                      )
                    : Center(
                        child: Image.file(
                        _image,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width / 0.5,
                        height: MediaQuery.of(context).size.height / 2.1,
                      )),
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.darkBackgroundGray,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: DesignCourseAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    125, MediaQuery.of(context).size.height / 2, 0, 0),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 58,
                      child: Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.darkBackgroundGray
                              .withOpacity(0.4),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                          border: Border.all(
                              color:
                                  DesignCourseAppTheme.grey.withOpacity(0.7)),
                        ),
                        child: GestureDetector(
                          child: Icon(
                            Icons.stop,
                            color: DesignCourseAppTheme.nearlyBlue,
                            size: 24,
                          ),
                          onTap: () => stopSpeaker(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 48,
                      height: 58,
                      child: Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.darkBackgroundGray
                              .withOpacity(0.4),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                          border: Border.all(
                              color:
                                  DesignCourseAppTheme.grey.withOpacity(0.7)),
                        ),
                        child: GestureDetector(
                          child: Icon(
                            Icons.volume_up,
                            color: DesignCourseAppTheme.nearlyBlue,
                            size: 24,
                          ),
                          onTap: () => speak(rectext),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, MediaQuery.of(context).size.height / 2.1, 0, 0),
                  child: printValue(_recognitions),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: DesignCourseAppTheme.nearlyBlack,
                    ),
                    onTap: () {
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              DesignCourseHomeScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "hello",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ])),
      onTap: () => speak(rectext),
    );
  }
}
